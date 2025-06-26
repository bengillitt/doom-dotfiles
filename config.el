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
(setq org-directory "~/org/")


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

;; (after! vterm
;;   (set-popup-rule! "^\\*vterm\\*" :size 0.2 :vsol -4 :select t :quit t))

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
  (org-roam-directory (file-truename "~/org/notes/"))
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
  ;; (org-roam-setup)
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
           )

          ("d" "daily note" plain
           "* Morning\n** What is one thing I can do today to get 1% better?\n%?\n** How do I want to feel at the end of today?\n\n** What would make today a 'win'?\n\n** What habit or mindset do I want to reinforce today?\n\n** If I face a challenge today, how will I respond differently than I normally do?\n\n* Evening\n** What did I do today that I'm proud of?\n\n** Where did I fall short today, and what can I learn from it?\n\n** What negative thoughts or behaviour popped up today? How could I respond better next time?\n\n** What gave me energy today? What drained it?\n\n** Did I act in alignment with my values today?\n"
           :if-new (file+head "%<%Y%m%d>.org"
                              "#+TITLE: ${date}\n")
           :unnarrowed t)))
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

;; (use-package! org-download
;;   :after org
;;   :config
;;   (setq org-download-image-dir "./images"
;;         org-download-method 'directory
;;         (add-hook 'dired-mode-hook 'org-download-enable)

;;         )


(defun my-yank-image-from-win-clipboard-through-powershell()
  (interactive)
  (let* ((powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
         (file-name (format-time-string "screenshot_%Y%m%d_%H%M%S.png"))
         ;; (file-path-powershell (concat "c:/Users/\$env:USERNAME/" file-name))
         (file-path-wsl (concat "~/org/images/" file-name))
         )
    (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"C:/Users/bengi/" file-name "\\\")\""))
    ;; (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"C:/Users/Public/" file-name "\\\")\""))
    (rename-file (concat "/mnt/c/Users/bengi/" file-name) file-path-wsl)
    (insert (concat "[[file:" file-path-wsl "]]"))
    (message "insert DONE.")
    ))

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

(setq org-agenda-files '("~/org/agenda/")) ;; Or wherever your dailies/todo files are

(defun my/vterm-new ()
  "Create a new vterm buffer with a unique name."
  (interactive)
  (let ((buffer (generate-new-buffer "*vterm*")))
    (with-current-buffer buffer
      (vterm-mode))
    (pop-to-buffer buffer)))

(map! :leader
      :desc "New vterm buffer"
      "o T" #'my/vterm-new)

(after! vterm
  (set-popup-rule! "^\\*vterm.*\\*$"
    :size 0.2
    :vslot -4
    :select t
    :quit t))


(setq gc-cons-threshold 100000000) ;; 100 MB, default is 800 KB

;; (with-eval-after-load 'flycheck
;;   (setq flycheck-disabled-checkers '(solidity-solium))

;;   ;; (setq-default flycheck-solidity-solhint-executable "solhint")
;;   ;; (setq-default flycheck-checker 'solidity-solhint)
;;   (flycheck-add-mode 'solhint-checker 'solidity-mode)
;;   (add-hook 'solidity-mode-hook
;;             (lambda ()
;;               (when (flycheck-checker-supports-major-mode-p 'solhint-checker 'solidity-mode)
;;                 (flycheck-select-checker 'solhint-checker)
;;                 (flycheck-mode 1)))))

(use-package solidity-mode
  :ensure t
  :config
  (setq solidity-solc-path "/home/bengillitt/.nvm/versions/node/v24.2.0/bin/solcjs")
  (setq solidity-solium-path "/home/bengillitt/.nvm/versions/node/v24.2.0/bin/solium")

  (setq solidity-flycheck-solc-checker-active t)
  (setq solidity-flycheck-solium-checker-active t)

  (setq flycheck-solidity-solc-addstd-contracts t)
  (setq flycheck-solidity-solium-soliumrcfile "/home/bengillitt/.soliumrc.json")

  (setq solidity-comment-style 'slash))

;; (add-hook 'solidity-mode-hook (lambda () (flycheck-mode -1)))
