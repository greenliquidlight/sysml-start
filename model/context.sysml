// SysML2 Context Model
// File: model/context.sysml
//
// This file defines the context model for the text-first SysML2 modeling
// workflow. It identifies the key actors, systems, and relationships that
// make up the workflow environment.

package WorkflowContext {

    private import WorkflowRequirements::*;

    // -------------------------------------------------------------------------
    // Actors (external to the core workflow system)
    // -------------------------------------------------------------------------

    part def ModelAuthor {
        doc /* A systems engineer or AI agent who creates and edits SysML2
               model artifacts. May use any text editor. */
    }

    part def Reviewer {
        doc /* A human who performs Verification and Validation of model
               artifacts via GitHub pull request review. Approves or requests
               changes before content is merged to main. */
        satisfy humanReviewRequirement;
    }

    // -------------------------------------------------------------------------
    // Systems and tools
    // -------------------------------------------------------------------------

    part def TextEditor {
        doc /* The text editor used to author model artifacts. VS Code is
               the recommended choice (workspace configuration in .vscode/
               provides extensions and task integration), but any text
               editor may be used. */
        satisfy authoringRequirement;
    }

    part def SysML2Extension {
        doc /* An optional editor extension providing SysML2 language support:
               syntax highlighting, diagnostics, and/or model navigation.
               Treated as optional — the workflow functions without it. */
    }

    part def ModelRepository {
        doc /* The Git repository containing all plain-text model artifacts
               (.sysml files), documentation (Markdown), generated diagrams
               (SVG), and workflow scripts. Serves as the single source of
               truth for all model content. */
        satisfy textStorageRequirement;
        satisfy editorAgnosticRequirement;
    }

    part def ValidationTool {
        doc /* The command-line validation script (scripts/validate-model)
               and any underlying SysML2 conformance checker it invokes.
               Reads model files and reports errors. */
        satisfy commandLineValidationRequirement;
        satisfy portabilityRequirement;
    }

    part def ViewRenderer {
        doc /* The command-line render script (scripts/render-diagrams) and
               any underlying SysML2 or diagram rendering engine it invokes.
               Reads model files; produces SVG output. */
        satisfy renderedDiagramRequirement;
        satisfy portabilityRequirement;
    }

    part def DocumentationBuilder {
        doc /* The command-line build script (scripts/build-docs) and any
               underlying document assembly tool (pandoc, mkdocs, etc.).
               Assembles Markdown sources and generated SVGs into navigable
               HTML (or PDF/docx) documentation. */
        satisfy embeddedDiagramsRequirement;
        satisfy exportReadinessRequirement;
        satisfy portabilityRequirement;
    }

    part def CISystem {
        doc /* The GitHub Actions CI system. Runs validate-model,
               render-diagrams, and build-docs automatically on every push
               and pull request. Provides pass/fail status to the PR review. */
        satisfy ciRenderingRequirement;
        satisfy documentationPublishingRequirement;
    }

    // -------------------------------------------------------------------------
    // Context model — relationships
    // -------------------------------------------------------------------------

    part workflowContext {

        // Actors
        part author : ModelAuthor;
        part reviewer : Reviewer;

        // Tools and systems
        part editor : TextEditor;
        part sysmlExt : SysML2Extension;
        part repo : ModelRepository;
        part validator : ValidationTool;
        part renderer : ViewRenderer;
        part docBuilder : DocumentationBuilder;
        part ci : CISystem;

        // Author uses a text editor to edit model files in the repository
        connection authorUsesEditor connect author to editor;
        connection editorEditsRepo connect editor to repo;

        // SysML2 extension augments the editor environment
        connection extAugmentsEditor connect sysmlExt to editor;

        // Validation tool reads model files from the repository
        connection validatorReadsRepo connect validator to repo;

        // Renderer reads model and view files from the repository;
        // produces SVG diagrams written back to the repository
        connection rendererReadsRepo connect renderer to repo;
        connection rendererWritesDiagrams connect renderer to repo;

        // Documentation builder reads docs and generated diagrams from the
        // repository; produces assembled HTML output
        connection docBuilderReadsRepo connect docBuilder to repo;

        // CI system orchestrates validate, render, and build
        connection ciRunsValidator connect ci to validator;
        connection ciRunsRenderer connect ci to renderer;
        connection ciRunsDocBuilder connect ci to docBuilder;

        // Reviewer consumes generated documentation and rendered diagrams
        connection reviewerConsumesRepo connect reviewer to repo;
    }

}
