// SysML2 Requirements Model
// File: model/requirements.sysml
//
// This file contains system requirements for the text-first SysML2
// modeling workflow.

package WorkflowRequirements {

    private import Requirements::*;

    // -------------------------------------------------------------------------
    // Top-level requirement
    // -------------------------------------------------------------------------

    requirement def WorkflowSystemRequirement :> RequirementCheck {
        doc /* The SysML2 modeling workflow system shall satisfy the following
               requirements to support systems engineers in a text-first,
               docs-as-code manner. */
    }

    // -------------------------------------------------------------------------
    // Functional requirements
    // -------------------------------------------------------------------------

    requirement textStorageRequirement : WorkflowSystemRequirement {
        doc /* REQ-001
               The workflow shall store all model artifacts as plain text files
               committed to a Git repository, with no binary or proprietary
               file formats required for core authoring. */
    }

    requirement authoringRequirement : WorkflowSystemRequirement {
        doc /* REQ-002
               The workflow shall support authoring and editing of model artifacts
               using Visual Studio Code or any text editor, with recommended
               extensions providing syntax highlighting and task integration.
               Authoring may be performed by a human systems engineer or by an
               AI agent drafting artifacts for human review. */
    }

    requirement commandLineValidationRequirement : WorkflowSystemRequirement {
        doc /* REQ-003
               The workflow shall support command-line validation of model files
               via a standalone executable script that returns a non-zero exit
               code on validation failure. */
    }

    requirement renderedDiagramRequirement : WorkflowSystemRequirement {
        doc /* REQ-004
               The workflow shall support rendering of SysML2 views as SVG
               diagrams using an automated command-line pipeline integrated
               with validation and documentation generation workflows. */
    }

    requirement embeddedDiagramsRequirement : WorkflowSystemRequirement {
        doc /* REQ-005
               The workflow shall support embedding rendered SVG diagrams as
               images in Markdown documentation files using relative file paths,
               enabling inline diagram viewing in GitHub, VS Code, and HTML
               exports. */
    }

    requirement ciRenderingRequirement : WorkflowSystemRequirement {
        doc /* REQ-006
               The workflow shall support automated rendering of diagrams and
               assembly of documentation in a GitHub Actions CI pipeline,
               triggered on every push and pull request. */
    }

    // -------------------------------------------------------------------------
    // Non-functional / quality requirements
    // -------------------------------------------------------------------------

    requirement editorAgnosticRequirement : WorkflowSystemRequirement {
        doc /* REQ-007
               The workflow should remain usable from any text editor other than
               VS Code, with no editing steps that require the VS Code GUI or
               extensions to function correctly. */
    }

    requirement portabilityRequirement : WorkflowSystemRequirement {
        doc /* REQ-008
               All command-line scripts shall use portable POSIX shell syntax
               (/usr/bin/env sh) so they can be executed on Linux, macOS, and
               Windows (WSL) without modification. */
    }

    requirement humanReviewRequirement : WorkflowSystemRequirement {
        doc /* REQ-009
               The workflow shall provide a structured GitHub pull request
               review process that serves as the Verification and Validation
               gate before model changes are merged to the main branch. */
    }

    requirement exportReadinessRequirement : WorkflowSystemRequirement {
        doc /* REQ-010
               The documentation build shall be structured to support future
               export to HTML, PDF, and docx formats via pandoc or equivalent
               tooling, using Markdown as the single source of truth. */
    }

    requirement documentationPublishingRequirement : WorkflowSystemRequirement {
        doc /* REQ-011
               The workflow shall support publishing the generated HTML
               documentation to a hosting target (such as GitHub Pages,
               GitLab Pages, or a self-hosted server) via an automated
               pipeline triggered on merge to the main branch. The hosting
               target shall be configurable without changes to the model or
               documentation sources. */
    }

    // Roadmap note: automatic extraction of model docs into a generated
    // reference artifact may be added in a future iteration.

    item def Work {
        doc /* A generic work item artifact used in example model flows. */
    }
}
