;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;; (package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;; (package! another-package
;;   :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;; (package! this-package
;;   :recipe (:host github :repo "username/repo"
;;            :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;; (package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;; (package! builtin-package :recipe (:nonrecursive t))
;; (package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;; (package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;; (package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;; (unpin! pinned-package)
;; ...or multiple packages
;; (unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;; (unpin! t)

;; (unpin! straight)
;; (unpin! org)
;; (unpin! diff-hl)
;; (unpin! with-editor)
;; (unpin! tablist)
;; (unpin! transient)
;; (unpin! bing-dict)

(package! bing-dict)                    ;C-c b to lookup word under cursor.
;; (package! helm-ag)                      ;f9 to invoke this command.

(package! ox-odt
  :recipe
  (
   :host github
   :repo "kjambunathan/org-mode-ox-odt"))

(package! org-extra-emphasis
  :recipe
  (
   :host github
   :repo "QiangF/org-extra-emphasis"))

(package! org-superstar-mode
  :recipe
  (
   :host github
   :repo "integral-dw/org-superstar-mode"))

;; (package! org-ai
;;   :recipe (:host github
;;            :repo "rksm/org-ai"
;;            :local-repo "org-ai"
;;            :files ("*.el" "README.md" "snippets")))

;; (package! shell-maker
;;   :recipe (:host github
;;            :repo "xenodium/shell-maker"
;;            :files ("shell-maker*.el")))
(package! ob-chatgpt-shell
  :recipe (:host github
           :repo "xenodium/ob-chatgpt-shell"
           :files ("*.el" "README.ORG")))
(package! chatgpt-shell
  :recipe (:host github
           :repo "xenodium/chatgpt-shell"
           ;; :files ("chatgpt-shell*.el" "README.org" "demos")
           ))

(package! pyim-basedict)
(package! pyim-tsinghua-dict
  :recipe
  (
   :host github
   :repo "redguardtoo/pyim-tsinghua-dict"))

;; (package! gptel
;;   :recipe
;;   (
;;    :host github
;;    :repo "karthink/gptel"))

;; (package! cnfonts
;;   :recipe
;;   (
;;    :host github
;;    :repo "tumashu/cnfonts"))

(package! zenburn
  :recipe
  (
   :host github
   :repo "bbatsov/zenburn-emacs"
   ))

(package! org-special-block-extras
  :recipe
  (
   :host github
   :repo "alhassy/org-special-block-extras"
   ))

(package! cal-china-x
  :recipe
  (
   :host github
   :repo "xwl/cal-china-x"
   ))

(package! asy-mode
  :recipe
  (
   :local-repo "/home/coeus/usr/local/texlive/2024/texmf-dist/asymptote"
   ))

(package! chinese-conv
  :recipe
  (
   :host github
   :repo "gucong/emacs-chinese-conv"
   ))

(package! company-box
  :recipe
  (
   :host github
   :repo "sebastiencs/company-box"
   ))

(package! csv-mode)

;; (package! ess-view-data
;;   :recipe
;;   (
;;    :host github
;;    :repo "ShuguangSun/ess-view-data"
;;    ))

(package! math-delimiters
  :recipe
  (
   :host github
   :repo "oantolin/math-delimiters"
   ))

(package! svg-lib
  :recipe
  (
   :host github
   :repo "rougier/svg-lib"
   ))

(package! sdcv
  :recipe
  (
   :host github
   :repo "manateelazycat/sdcv"
   ))

(package! xah-wolfram-mode
  :recipe
  (
   :host github
   :repo "xahlee/xah-wolfram-mode"
   ))

(package! cape
  :recipe
  (
   :host github
   :repo "minad/cape"
   ))

(package! powerthesaurus
  :recipe
  (
   :host github
   :repo "SavchenkoValeriy/emacs-powerthesaurus"
   ))

(package! org-download
  :recipe
  (
   :host github
   :repo "abo-abo/org-download"
   ))

;; (package!
;;   aider :recipe
;;   (
;;    :host github
;;    :repo "tninja/aider.el"
;;    :files ("aider.el" "aider-core.el" "aider-file.el" "aider-code-change.el" "aider-discussion.el" "aider-prompt-mode.el" "aider-doom.el")
;;    ))
;; (package!
;;   aider :recipe
;;   (
;;    :host github
;;    :repo "tninja/aider.el"
;;    ;; :files ("aider.el" "aider-doom.el")
;;    ))

(package! google-translate
  :recipe
  (
   :host github
   :repo "atykhonov/google-translate"
   ))

;; (package! aidermacs
;;   :recipe
;;   (
;;    :host github
;;    :repo "MatthewZMD/aidermacs"
;;    ))

(package! pdffontetc
  :recipe
  (
   :host github
   :repo "emacsomancer/pdffontetc"
   ))

;; (package! copilot
;;   :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

;; only highlight the current region when enabled.
(package! focus
  :recipe
  (
   :host github
   :repo "larstvei/Focus"
   ))

;; rainbow-delimiters-mode
(package! rainbow-delimiters)

;; Ensure Emacs automatically removes trailing whitespace before saving buffers
(package! stripspace)
