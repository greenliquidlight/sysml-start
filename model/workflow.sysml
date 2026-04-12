// SysML2 Workflow / Behavior Model
// File: model/workflow.sysml
//
// This file defines the workflow activities (actions) for the text-first
// SysML2 modeling workflow. It describes the sequenced steps from editing
// through review.

package WorkflowBehavior {

    public import WorkflowContext::*;
    public import ScalarValues::*;

    // -------------------------------------------------------------------------
    // Action definitions (workflow steps)
    // -------------------------------------------------------------------------

    action def EditModel {
                doc /* The ModelAuthor creates or modifies .sysml files in model/
                             using VS Code or any text editor. Changes are
               committed to a Git feature branch. */

        in  : ModelRepository;   // current model state
        out : ModelRepository;   // updated model state
    }

    action def ValidateModel {
        doc /* The ValidationTool reads all model files and checks for
               structural and syntactic correctness. Reports errors to stdout.
               Exits nonzero on failure, blocking CI and the PR. */

        in  : ModelRepository;   // model files to validate
        out validationResult : Boolean;
    }

    action def RenderDiagrams {
        doc /* The ViewRenderer reads model files and
               produces SVG diagram files in generated/diagrams/. */

        in  : ModelRepository;   // model + view source files
        out : ModelRepository;   // repository updated with generated SVGs
    }

    action def BuildDocs {
        doc /* The DocumentationBuilder assembles Markdown documents and
               generated SVG diagrams into an HTML index. TODO: integrate
               pandoc or mkdocs for polished multi-format output. */

        in  : ModelRepository;   // docs/ + generated/diagrams/
        out : ModelRepository;   // repository updated with generated docs
    }

    action def ReviewOutput {
        doc /* The human Reviewer examines the rendered diagrams, updated
               documentation, and model diffs via a GitHub pull request.
               Approves the PR (merge to main) or requests changes. */

        in  : ModelRepository;   // full repository state on the PR branch
        out reviewDecision : String;  // 'approved' | 'changes-requested'
    }

    // -------------------------------------------------------------------------
    // Workflow sequence
    // -------------------------------------------------------------------------

    action textFirstWorkflow {
        doc /* The complete edit → validate → render → build → review pipeline.
               Steps are sequential; a failure at any step should be resolved
               before proceeding. */

        action edit         : EditModel;
        action validate     : ValidateModel;
        action renderDiags  : RenderDiagrams;
        action build        : BuildDocs;
        action review       : ReviewOutput;

        // Sequencing via succession (SysML v2 preferred ordering syntax)
        succession first edit then validate;
        succession first validate then renderDiags;
        succession first renderDiags then build;
        succession first build then review;

        // Guard: only proceed past validate if validation passed
        // (Non-zero exit from validate-model script enforces this in CI)
    }

}
