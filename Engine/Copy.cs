using System.Text;

namespace PowerShellWrappers.Engine
{
    public static partial class Operations
    {
        public static void Copy(IEnumerable<(string source, string destination)> pathPairs)
        {
            // Convert the list of path pairs into null-terminated strings
            var fromPathsBuilder = new StringBuilder();
            var toPathsBuilder = new StringBuilder();
            foreach ((string source, string destination) in pathPairs)
            {
                fromPathsBuilder.Append(source).Append('\0');
                toPathsBuilder.Append(destination).Append('\0');
            }
            // Double null-terminate the strings
            fromPathsBuilder.Append('\0'); 
            toPathsBuilder.Append('\0');

            // Set up the SHFILEOPSTRUCT structure
            var fileOp = new SHFILEOPSTRUCT
            {
                wFunc = FO_Func.FO_COPY,
                pFrom = fromPathsBuilder.ToString(),
                pTo = toPathsBuilder.ToString(),
                fFlags = FILEOP_FLAGS.FOF_ALLOWUNDO | FILEOP_FLAGS.FOF_NOCONFIRMATION | FILEOP_FLAGS.FOF_NOCONFIRMMKDIR | FILEOP_FLAGS.FOF_RENAMEONCOLLISION | FILEOP_FLAGS.FOF_MULTIDESTFILES
            };

            // Perform the file operation
            var result = SHFileOperation(ref fileOp);

            // Check the result
            if (result != 0)
            {
                throw new InvalidOperationException($"Error copying: {GetErrorMessage(result)}");
            }
        }
    }
}