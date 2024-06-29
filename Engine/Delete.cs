using System.Text;

namespace PowerShellWrappers.Engine
{
    public static partial class Operations
    {
        public static void Delete(IEnumerable<string> paths)
        {
            // Convert the list of paths into a null-terminated string
            var pathsBuilder = new StringBuilder();
            foreach (string path in paths)
            {
                pathsBuilder.Append(path).Append('\0');
            }
            // Double null-terminate the string
            pathsBuilder.Append('\0');

            // Set up the SHFILEOPSTRUCT structure
            var fileOp = new SHFILEOPSTRUCT
            {
                wFunc = FO_Func.FO_DELETE,
                pFrom = pathsBuilder.ToString(),
                fFlags = FILEOP_FLAGS.FOF_ALLOWUNDO | FILEOP_FLAGS.FOF_NOCONFIRMATION
            };

            // Perform the file operation
            var result = SHFileOperation(ref fileOp);

            // Check the result
            if (result != 0)
            {
                throw new InvalidOperationException($"Error deleting: {GetErrorMessage(result)}");
            }
        }
    }
}