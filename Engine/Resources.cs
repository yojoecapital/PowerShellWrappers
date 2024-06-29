using System.Runtime.InteropServices;

namespace PowerShellWrappers.Engine
{
    public static partial class Operations
    {
        [DllImport("shell32.dll", CharSet = CharSet.Auto)]
        private static extern int SHFileOperation(ref SHFILEOPSTRUCT lpFileOp);

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
        private struct SHFILEOPSTRUCT
        {
            public IntPtr hwnd;
            public FO_Func wFunc;
            public string pFrom;
            public string pTo;
            public FILEOP_FLAGS fFlags;
            public bool fAnyOperationsAborted;
            public IntPtr hNameMappings;
            public string lpszProgressTitle;
        }

        private enum FO_Func : uint
        {
            FO_MOVE = 0x0001,
            FO_COPY = 0x0002,
            FO_DELETE = 0x0003
        }

        [Flags]
        private enum FILEOP_FLAGS : ushort
        {
            FOF_MULTIDESTFILES = 0x0001,
            FOF_CONFIRMMOUSE = 0x0002,
            FOF_SILENT = 0x0004,
            FOF_RENAMEONCOLLISION = 0x0008,
            FOF_NOCONFIRMATION = 0x0010, // Don't prompt the user.
            FOF_WANTMAPPINGHANDLE = 0x0020,
            FOF_ALLOWUNDO = 0x0040, // Allow undo
            FOF_FILESONLY = 0x0080,
            FOF_SIMPLEPROGRESS = 0x0100,
            FOF_NOCONFIRMMKDIR = 0x0200,
            FOF_NOERRORUI = 0x0400,
            FOF_NOCOPYSECURITYATTRIBS = 0x0800,
            FOF_NORECURSION = 0x1000,
            FOF_NO_CONNECTED_ELEMENTS = 0x2000,
            FOF_WANTNUKEWARNING = 0x4000,
            FOF_NORECURSEREPARSE = 0x8000
        }

        private static string GetErrorMessage(int errorCode)
        {
            // Convert the error code to a human-readable message
            return errorCode switch
            {
                0x00000002 => "The system cannot find the file specified.",
                0x00000003 => "The system cannot find the path specified.",
                0x00000005 => "Access is denied.",
                0x000000E5 => "The file exists.",
                0x00000057 => "The parameter is incorrect.",
                0x0000006D => "The specified network name is no longer available.",
                0x0000007B => "The filename, directory name, or volume label syntax is incorrect.",
                0x000000C0 => "The operation was canceled by the user.",
                0x00000103 => "The system cannot find the file specified.",
                _ => errorCode.ToString()
            };
        }
    }
}