;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16))
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-spacegrey)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/notes/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! nerd-icons
  (add-to-list 'nerd-icons-extension-icon-alist '("sol" nerd-icons-devicon "nf-dev-solidity" :face nerd-icons-blue)))

(global-set-key [f8] 'neotree-toggle)

(setq neo-theme 'nerd-icons)

(add-to-list 'initial-frame-alist '(fullscreen . maximized)) ;; Or 'fullboth for true fullscreen

(map! :leader
      :desc "Toggle neotree"
      "t n" #'neotree-toggle)

(after! vterm
  (set-popup-rule! "^\\*vterm\\*" :size 0.2 :vsol -4 :select t :quit t))

;; Create file with Neotree
(defun neotree-create-file ()
  "Focus NeoTree and create a new file"
  (interactive)
  ;; Ensure NeoTree is open and focused
  (neotree-show)
  (select-window (neo-global--get-window))
  (call-interactively 'neotree-create-node))

(global-set-key (kbd "C-c C-n") #'neotree-create-file)

;; I haven't got a function here due to the importance of already having Neotree focused
(global-set-key (kbd "C-c C-d") #'neotree-delete-node)

(global-set-key (kbd "C-c C-r") #'neotree-rename-node)

(global-set-key (kbd "C-c C-p") #'neotree-copy-node)

(setq neo-smart-open nil)

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/notes/org-roam/"))
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-C n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)
         :map org-mode-map
         ("C-M-i"    .    completion-at-point))
  :config
  (org-roam-setup)
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  (require 'org-roam-export)

  ;; (setq org-roam-node-display-template
  ;;       (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))

  (setq org-roam-capture-templates
        '(("r" "research note" plain
           "* Summary\n\n* Concept\n\n%?\n\n* References"
           :if-new (file+head "${slug}.org"
                              "#+TITLE: ${title}\n#+ROAM_TAGS: \n")
           :unnarrowed t

           )))
  )

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package! org-download
  :after org
  :bind
  (:map org-mode-map
        (("s-Y" . org-download-screenshot)
         ("s-y" . org-download-yank))))

(setq xclip-method 'wl-clipboard)

(defun my/org-visual-line-setup ()
  "Enable visual line mode and remap j/k in Org buffers."
  (visual-line-mode 1)
  (setq-local evil-respect-visual-line-mode t)
  (evil-local-set-key 'normal "j" 'evil-next-visual-line)
  (evil-local-set-key 'normal "k" 'evil-previous-visual-line)
  (evil-local-set-key 'motion "j" 'evil-next-visual-line)
  (evil-local-set-key 'motion "k" 'evil-previous-visual-line))

(add-hook 'org-mode-hook #'my/org-visual-line-setup)
