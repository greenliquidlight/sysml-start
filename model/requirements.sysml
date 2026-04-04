// SysML2 Requirements Model
// File: model/requirements.sysml
//
// This file contains starter system requirements for the text-first SysML2
// modeling workflow. Syntax is approximate SysML2; adjust as needed for your
// tooling.

package WorkflowRequirements {

    // -------------------------------------------------------------------------
    // Top-level requirement
    // -------------------------------------------------------------------------

    requirement def WorkflowSystemRequirement {
        doc /* The SysML2 modeling workflow system shall satisfy the following
               requirements to support systems engineers in a text-first,
               docs-as-code manner. */
    }

    // -------------------------------------------------------------------------
    // Functional requirements
    // -------------------------------------------------------------------------

    requirement <'REQ-001'> textStorageRequirement : WorkflowSystemRequirement {
        doc /* The workflow shall store all model artifacts as plain text files
               committed to a Git repository, with no binary or proprietary
               file formats required for core authoring. */
    }

    requirement <'REQ-002'> vsCodeEditingRequirement : WorkflowSystemRequirement {
        doc /* The workflow shall support authoring and editing of model artifacts
               using Visual Studio Code, with recommended extensions providing
               syntax highlighting and task integration. */
    }

    requirement <'REQ-003'> commandLineValidationRequirement : WorkflowSystemRequirement {
        doc /* The workflow shall support command-line validation of model files
               via a standalone executable script that returns a non-zero exit
               code on validation failure. */
    }

    requirement <'REQ-004'> renderedDiagramRequirement : WorkflowSystemRequirement {
        doc /* The workflow shall support rendering of SysML2 views as SVG
               diagrams, with rendered output available from day 1 via
               placeholder generation if a real renderer is not yet integrated. */
    }

    requirement <'REQ-005'> embeddedDiagramsRequirement : WorkflowSystemRequirement {
        doc /* The workflow shall support embedding rendered SVG diagrams as
               images in Markdown documentation files using relative file paths,
               enabling inline diagram viewing in GitHub, VS Code, and HTML
               exports. */
    }

    requirement <'REQ-006'> ciRenderingRequirement : WorkflowSystemRequirement {
        doc /* The workflow shall support automated rendering of diagrams and
               assembly of documentation in a GitHub Actions CI pipeline,
               triggered on every push and pull request. */
    }

    // -------------------------------------------------------------------------
    // Non-functional / quality requirements
    // -------------------------------------------------------------------------

    requirement <'REQ-007'> editorAgnosticRequirement : WorkflowSystemRequirement {
        doc /* The workflow should remain usable from any text editor other than
               VS Code, with no editing steps that require the VS Code GUI or
               extensions to function correctly. */
    }

    requirement <'REQ-008'> portabilityRequirement : WorkflowSystemRequirement {
        doc /* All command-line scripts shall use portable POSIX shell syntax
               (/usr/bin/env sh) so they can be executed on Linux, macOS, and
               Windows (WSL) without modification. */
    }

    requirement <'REQ-009'> humanReviewRequirement : WorkflowSystemRequirement {
        doc /* The workflow shall provide a structured GitHub pull request
               review process that serves as the Verification and Validation
               gate before model changes are merged to the main branch. */
    }

    requirement <'REQ-010'> exportReadinessRequirement : WorkflowSystemRequirement {
        doc /* The documentation build shall be structured to support future
               export to HTML, PDF, and docx formats via pandoc or equivalent
               tooling, using Markdown as the single source of truth. */
    }

}
