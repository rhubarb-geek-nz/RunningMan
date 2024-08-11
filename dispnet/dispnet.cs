/***********************************
 * Copyright (c) 2024 Roger Brown.
 * Licensed under the MIT License.
 ****/

using System;
using System.Linq;
using System.Runtime.InteropServices;

namespace RhubarbGeekNzRunningMan
{
    internal class Program
    {
        static void Main(string[] args)
        {
            string progId = "RhubarbGeekNz.RunningMan";
            CoInitializeSecurity(IntPtr.Zero, -1, IntPtr.Zero, IntPtr.Zero, RpcAuthnLevel.Pkt, RpcImpLevel.Impersonate, IntPtr.Zero, EoAuthnCap.None, IntPtr.Zero);

#if NETFRAMEWORK
            object active = Marshal.GetActiveObject(progId);
#else
            Guid guid = Type.GetTypeFromProgID(progId).GUID;
            GetActiveObject(ref guid, IntPtr.Zero, out object active);
#endif
            IHelloWorld helloWorld = active as IHelloWorld;

            foreach (int hint in args.Length == 0 ? new int[] { 1, 2, 3, 4, 5 } : args.Select(t => Int32.Parse(t)).ToArray())
            {
                string result = helloWorld.GetMessage(hint);
                Console.WriteLine($"{hint} {result}");
            }
        }

        public enum RpcAuthnLevel
        {
            Default = 0,
            None = 1,
            Connect = 2,
            Call = 3,
            Pkt = 4,
            PktIntegrity = 5,
            PktPrivacy = 6
        }

        public enum RpcImpLevel
        {
            Default = 0,
            Anonymous = 1,
            Identify = 2,
            Impersonate = 3,
            Delegate = 4
        }

        public enum EoAuthnCap
        {
            None = 0x00,
            MutualAuth = 0x01,
            StaticCloaking = 0x20,
            DynamicCloaking = 0x40,
            AnyAuthority = 0x80,
            MakeFullSIC = 0x100,
            Default = 0x800,
            SecureRefs = 0x02,
            AccessControl = 0x04,
            AppID = 0x08,
            Dynamic = 0x10,
            RequireFullSIC = 0x200,
            AutoImpersonate = 0x400,
            NoCustomMarshal = 0x2000,
            DisableAAA = 0x1000
        }

        [DllImport("ole32.dll", PreserveSig = false)]
        private static extern void CoInitializeSecurity(IntPtr pVoid, int cAuthSvc, IntPtr asAuthSvc, IntPtr pReserved1, RpcAuthnLevel level, RpcImpLevel impers, IntPtr pAuthList, EoAuthnCap dwCapabilities, IntPtr pReserved3);

        [DllImport("oleaut32.dll", PreserveSig = false)]
        private static extern void GetActiveObject(ref Guid rclsid, IntPtr pvReserved, [MarshalAs(UnmanagedType.IUnknown)] out Object ppunk);
    }
}
