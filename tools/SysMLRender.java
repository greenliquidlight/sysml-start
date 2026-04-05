import net.sourceforge.plantuml.FileFormat;
import net.sourceforge.plantuml.FileFormatOption;
import net.sourceforge.plantuml.SourceStringReader;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Reads SysMLInteractive REPL output from stdin, extracts each
 * {@code @startuml ... @enduml} block in document order, and renders
 * each block to an SVG file using the PlantUML library that is bundled
 * inside the OMG kernel JAR.
 *
 * <p>Running PlantUML <em>from within the same JAR</em> is the key: the
 * {@code skin/sysmlbw.skin} file that SysMLInteractive embeds in its
 * {@code %viz} output is also a classpath resource inside that JAR, so
 * PlantUML resolves it automatically — avoiding the "Cannot find style
 * sysmlbw" error produced by an external {@code plantuml} CLI.</p>
 *
 * <p>Compile once against the kernel JAR:</p>
 * <pre>
 *   javac -cp "$JAR" -d "$TOOLS_DIR" "$TOOLS_DIR/SysMLRender.java"
 * </pre>
 *
 * <p>Then pipe REPL output through it:</p>
 * <pre>
 *   build_repl_input \
 *     | java -cp "$JAR" org.omg.sysml.interactive.SysMLInteractive "$LIB" 2>/dev/null \
 *     | java -cp "$JAR:$TOOLS_DIR" SysMLRender "$DIAGRAMS_DIR" \
 *           context.svg artifact-flow.svg requirements.svg
 * </pre>
 *
 * <p>Exit codes: {@code 0} if every named output was rendered;
 * {@code 1} if any block was missing or rendering failed.</p>
 */
public class SysMLRender {

    public static void main(String[] args) throws IOException {
        if (args.length < 2) {
            System.err.println("Usage: SysMLRender <outputDir> <name.svg> [<name2.svg> ...]");
            System.exit(1);
        }

        Path outDir = Path.of(args[0]);
        List<String> names = Arrays.asList(args).subList(1, args.length);
        Files.createDirectories(outDir);

        // Read the full REPL output from stdin and locate each PlantUML block.
        String replOutput = new String(System.in.readAllBytes());
        List<String> blocks = extractBlocks(replOutput);

        int failed = 0;
        for (int i = 0; i < names.size(); i++) {
            String name = names.get(i);
            if (i >= blocks.size()) {
                System.err.println("  [WARN]  " + name
                        + " — PlantUML block " + (i + 1) + " not found in REPL output");
                failed++;
                continue;
            }
            Path outFile = outDir.resolve(name);
            try (OutputStream out = Files.newOutputStream(outFile)) {
                new SourceStringReader(blocks.get(i))
                        .outputImage(out, new FileFormatOption(FileFormat.SVG));
            }
            System.out.println("  [OK]    " + name);
        }

        if (failed > 0) {
            System.err.println(
                    "\nRendering FAILED: " + failed + " diagram(s) could not be generated.");
            System.exit(1);
        }
    }

    /** Returns all {@code @startuml...@enduml} blocks found in {@code text}, in order. */
    private static List<String> extractBlocks(String text) {
        List<String> blocks = new ArrayList<>();
        int pos = 0;
        while (pos < text.length()) {
            int start = text.indexOf("@startuml", pos);
            if (start < 0) break;
            int end = text.indexOf("@enduml", start);
            if (end < 0) break;
            end += "@enduml".length();
            blocks.add(text.substring(start, end));
            pos = end;
        }
        return blocks;
    }
}
