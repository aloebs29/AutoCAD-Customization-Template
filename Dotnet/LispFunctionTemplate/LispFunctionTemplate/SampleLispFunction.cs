using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.Geometry;
using Autodesk.AutoCAD.EditorInput;
using System.IO;

[assembly: ExtensionApplication(null)]
[assembly: CommandClass(typeof(LispFunctionTemplate.SampleCommandClass))]

namespace LispFunctionTemplate
{
    public class SampleCommandClass
    {
        [LispFunction("HelloLispFunction")]
        public static void SampleLispFunction(ResultBuffer rbArgs)
        {
            // Current doc
            Document acDoc = Application.DocumentManager.MdiActiveDocument;

            // Var to hold string that was passed in
            string rbString = "";
            // Get the first result buffer arg
            if (rbArgs != null)
            {
                TypedValue rb = rbArgs.AsArray()[0];
                // Make sure it was a string
                if (rb.TypeCode == (int)LispDataType.Text)
                {
                    rbString = rb.Value.ToString();
                }
                else
                {
                    acDoc.Editor.WriteMessage("Must provide a string as an argument.");
                    return;
                }
            }
            else
            {
                acDoc.Editor.WriteMessage("Must provide a string as an argument.");
                return;
            }

            // Write hello from lisp function, along with whatever string was passed
            acDoc.Editor.WriteMessage($"Hello from a lisp function. The string argument passed to this function: {rbString}");
        }
    }
}
