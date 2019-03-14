using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.Geometry;
using Autodesk.AutoCAD.EditorInput;
using System.IO;

[assembly: ExtensionApplication(null)]
[assembly: CommandClass(typeof(CommandMethodTemplate.SampleCommandClass))]
namespace CommandMethodTemplate
{
    public class SampleCommandClass
    {
        [CommandMethod("HelloCommandMethod")]
        public static void SampleCommandMethod()
        {
            // Current doc
            Document acDoc = Application.DocumentManager.MdiActiveDocument;

            // Write to editor
            acDoc.Editor.WriteMessage("Hello from a command method.");
        }
    }
}
