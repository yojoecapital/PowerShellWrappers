using PowerShellWrappers.Engine;

namespace PowerShellWrappers
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var operation = args[0].ToUpper();
                var items = args.Skip(1).Select(Path.GetFullPath);
                if (operation.Equals("DELETE"))
                {
                    Operations.Delete(items);
                }
                else if (operation.ToUpper().Equals("COPY"))
                {
                    Operations.Copy(ToPairwise(items));
                }
                else if (operation.ToUpper().Equals("MERGECOPY"))
                {
                    Operations.MergeCopy(ToPairwise(items));
                }
                else if (operation.ToUpper().Equals("MOVE"))
                {
                    Operations.Move(ToPairwise(items));
                }
                else if (operation.ToUpper().Equals("MERGEMOVE"))
                {
                    Operations.MergeMove(ToPairwise(items));
                }
                else throw new Exception("Command not recognized.");
            }
            catch (Exception exception)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine(exception.Message);
                Console.ResetColor();
            }
        }

        public static IEnumerable<(string, string)> ToPairwise(IEnumerable<string> source)
        {
            ArgumentNullException.ThrowIfNull(source);
            using var enumerator = source.GetEnumerator();
            while (enumerator.MoveNext())
            {
                var first = enumerator.Current;
                if (!enumerator.MoveNext())
                {
                    throw new InvalidOperationException("The input sequence contains an odd number of elements.");
                }
                var second = enumerator.Current;
                yield return (first, second);
            }
        }
    }
}
