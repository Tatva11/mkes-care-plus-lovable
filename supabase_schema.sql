-- MKES Care+ Supabase Schema

-- 1. Create custom enum for roles if desired (optional, using text is easier, we will use text for simplicity)
-- Role constraints: 'admin' or 'staff'

-- 2. Create the profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone_number TEXT,
  department TEXT,
  designation TEXT,
  role TEXT NOT NULL CHECK (role IN ('admin', 'staff')),
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Enable Row Level Security (RLS) on profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 4. Create helper function to check if user is admin (bypasses RLS)
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() 
    AND role = 'admin' 
    AND is_active = true
  );
END;
$$;

-- 5. RLS Policies

-- Policy: Users can view own profile
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile" 
ON public.profiles 
FOR SELECT 
USING (auth.uid() = id);

-- Policy: Admins can view all profiles
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;
CREATE POLICY "Admins can view all profiles" 
ON public.profiles 
FOR SELECT 
USING (is_admin());

-- Policy: Admins can insert profiles
DROP POLICY IF EXISTS "Admins can insert profiles" ON public.profiles;
CREATE POLICY "Admins can insert profiles" 
ON public.profiles 
FOR INSERT 
WITH CHECK (is_admin());

-- Policy: Admins can update all profiles
DROP POLICY IF EXISTS "Admins can update all profiles" ON public.profiles;
CREATE POLICY "Admins can update all profiles" 
ON public.profiles 
FOR UPDATE 
USING (is_admin());

-- Policy: Admins can delete profiles
DROP POLICY IF EXISTS "Admins can delete profiles" ON public.profiles;
CREATE POLICY "Admins can delete profiles" 
ON public.profiles 
FOR DELETE 
USING (is_admin());

-- Note: Because RLS prevents new admins from inserting the VERY FIRST admin profile 
-- (chicken-and-egg problem), you should create the first admin manually via the 
-- Supabase SQL Editor by running:
-- INSERT INTO public.profiles (id, full_name, email, role) 
-- VALUES ('<uid-from-auth-users>', 'Super Admin', 'admin@example.com', 'admin');

-- 6. Create RPC function for secure user deletion (admin only)
-- This function allows admins to delete users from auth.users via a secure RPC call
-- instead of exposing the service_role key in the Flutter app.
CREATE OR REPLACE FUNCTION delete_user_by_admin(target_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Check if the caller is an active admin
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only active admins can delete users';
  END IF;
  
  -- Delete the user from auth.users (this cascades to profiles)
  DELETE FROM auth.users WHERE id = target_user_id;
END;
$$;

-- 7. Create RPC function for secure user creation (admin only)
-- This function allows admins to create users with both auth and profile in one call
CREATE OR REPLACE FUNCTION create_user_by_admin(
  p_email TEXT,
  p_password TEXT,
  p_full_name TEXT,
  p_phone_number TEXT DEFAULT NULL,
  p_department TEXT DEFAULT NULL,
  p_designation TEXT DEFAULT NULL,
  p_role TEXT DEFAULT 'staff'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  new_user_id UUID;
BEGIN
  -- Check if the caller is an active admin
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only active admins can create users';
  END IF;
  
  -- Create the auth user
  INSERT INTO auth.users (email, encrypted_password, email_confirmed_at)
  VALUES (p_email, crypt(p_password, gen_salt('bf')), now())
  RETURNING id INTO new_user_id;
  
  -- Insert the profile row
  INSERT INTO public.profiles (
    id,
    full_name,
    email,
    phone_number,
    department,
    designation,
    role,
    is_active
  ) VALUES (
    new_user_id,
    p_full_name,
    p_email,
    p_phone_number,
    p_department,
    p_designation,
    p_role,
    true
  );
  
  RETURN new_user_id;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION delete_user_by_admin(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION create_user_by_admin(TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT) TO authenticated;
