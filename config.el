;;; package --- $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; commentary:
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;;; code:

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Bashee Wang"
      user-mail-address "bashee.wang@gmail.com")

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
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues! 测试
;; Set 22/20 for smaller screen and 28 for 27" screen.
(setq doom-font
      (font-spec
       :family "IosevkaTerm Nerd Font Mono"
       :size 20
       :weight 'regular)
      doom-variable-pitch-font
      (font-spec
       :family "IosevkaTerm Nerd Font Mono"
       :size 20))

;; (defun my-cjk-font()
;;   (dolist (charset '(kana han cjk-misc symbol bopomofo))
;;     (set-fontset-font t charset (font-spec :family "FZSongKeBenXiuKai-R-GBK" :size 20))))

(defun my-cjk-font()
  "先设置基础 CJK 字符集（这会覆盖绝大多数常用汉字）."
  (dolist (charset '(kana han cjk-misc symbol bopomofo hangul))
    (cond ((eq charset 'hangul)
           (set-fontset-font t charset (font-spec :family "Noto Serif KR" :size 20)))
          (t
           (set-fontset-font t charset (font-spec :family "FZSongKeBenXiuKai-R-GBK" :size 20)))))

  ;; 2. 专门为扩展区汉字设置字体（放在循环之后，确保覆盖掉上述 han 字符集对生僻字的接管）
  (set-fontset-font t
                    '(#x20000 . #x3FFFF)  ; 建议扩大范围：涵盖 Ext-B, C, D, E, F, G 等所有扩展区
                    (font-spec :family "SimSun-ExtB" :size 20)
                    nil
                    'prepend))  ; 'prepend 告诉 Emacs 将此规则放在最前面，优先匹配
(add-hook 'after-setting-font-hook #'my-cjk-font)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'whiteboard)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; 强制开启全局光标位置记忆功能
(save-place-mode 1)

;; ========================================================
;; 自动记忆并恢复 Emacs 窗口的位置与大小 (含最大化状态)
;; ========================================================
(defvar my-saved-frame-file (expand-file-name ".frame-geometry" doom-user-dir)
  "存放窗口状态的本地缓存文件.")

;; 1. 启动时：如果存在记录文件，读取并将其注入到初始化参数中
(when (file-exists-p my-saved-frame-file)
  (ignore-errors
    (with-temp-buffer
      (insert-file-contents my-saved-frame-file)
      (let ((geometry (read (current-buffer))))
        ;; 注入到新框架的默认参数中
        (setq initial-frame-alist (append geometry initial-frame-alist))
        (setq default-frame-alist (append geometry default-frame-alist))
        ;; 如果当前已经是 GUI 图形界面，则立即对当前窗口生效
        (when (display-graphic-p)
          (modify-frame-parameters (selected-frame) geometry))))))

;; 2. 退出时：抓取当前窗口的长宽、坐标以及是否最大化，并保存进缓存文件
(add-hook 'kill-emacs-hook
          (lambda ()
            ;; 只在图形界面下记录，避免终端 (emacs -nw) 启动时覆盖正确的数据
            (when (display-graphic-p)
              (with-temp-file my-saved-frame-file
                (prin1 `((width . ,(frame-parameter nil 'width))
                         (height . ,(frame-parameter nil 'height))
                         (top . ,(frame-parameter nil 'top))
                         (left . ,(frame-parameter nil 'left))
                         (fullscreen . ,(frame-parameter nil 'fullscreen)))
                       (current-buffer))))))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/myproj/org/")

;; suggest to remove them by gemini.
;; (prefer-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (setq default-buffer-file-coding-system 'utf-8)
;; (setq! default-input-method "rime")

;; (global-visual-line-mode)
(global-auto-revert-mode)

;; ispell dictionary config.
(after! ispell
  ;; 使用 doom-user-dir 保持路径动态拼接，确保配置在任何机器上都能无缝漫游
  ;; 设置个人词典的绝对路径
  (setq ispell-personal-dictionary (expand-file-name ".ispell_personal" doom-user-dir)
        ispell-alternate-dictionary (expand-file-name "english-words.txt" doom-user-dir)))

;; All my shortcuts
(global-set-key [C-right] 'forward-sexp)
(global-set-key [C-left] 'backward-sexp)
(global-set-key [M-right] 'right-word)
(global-set-key [M-left] 'left-word)
(global-set-key (kbd "C-x <up>") 'other-window)
(global-set-key (kbd "C-x <down>") 'other-window)
(global-set-key (kbd "C-c 0") 'search-forward)
(global-set-key (kbd "C-c +") 'pop-global-mark)
(global-set-key (kbd "C-c \"") 'align-entire)

(global-set-key [S-f1] 'calendar)
;; (global-set-key [f3] 'ibuffer)
(global-set-key [f4] 'kill-current-buffer)

(global-set-key (kbd "C-c b") 'bing-dict-brief)
(global-set-key (kbd "C-c d") 'sdcv-search-pointer)
(global-set-key (kbd "C-c D") 'sdcv-search-pointer+)
(global-set-key (kbd "C-c C-p") 'delete-pair)
(global-set-key (kbd "C-c y") 'google-translate-at-point)
(global-set-key (kbd "C-x f") 'find-file-at-point)

;; ========================================================
;; Consult 核心功能键位绑定 (非 Evil 模式)
;; ========================================================

;; 1. 搜索类功能 (挂载到原生 M-s 前缀下)
(global-set-key (kbd "M-s r") 'consult-ripgrep)
(global-set-key (kbd "M-s f") 'consult-fd)
(global-set-key (kbd "M-s l") 'consult-line)    ;; 极速单文件内搜索，极其强大
(global-set-key (kbd "M-s L") 'consult-locate)

;; 2. 跳转与大纲功能 (挂载到原生 M-g 前缀下)
(global-set-key (kbd "M-g i") 'consult-imenu)   ;; 全局函数/标题大纲跳转
(global-set-key (kbd "M-g x") 'consult-lsp-diagnostics) ;; 快速查看当前项目的全部报错
(global-set-key (kbd "M-g f") 'consult-flycheck) ;; 快速查看当前项目的全部报错
(global-set-key (kbd "M-g m") 'consult-flymake) ;; 快速查看当前项目的全部报错

;; 3. 【极度推荐】直接覆盖 Emacs 的高频原生快捷键
(global-set-key (kbd "M-y") 'consult-yank-pop)  ;; 替换原生 M-y，提供剪贴板历史可视化菜单
(global-set-key (kbd "C-x m") 'consult-buffer)  ;; 替换原生 C-x b，整合最近文件与 Buffer 列表

;; (global-set-key [f6] 'consult-lsp-diagnostics)
;; (global-set-key [f7] 'consult-flycheck)
;; (global-set-key [f8] 'consult-fd)
;; (global-set-key [f9] 'consult-ripgrep)
;; (global-set-key [C-f9] 'consult-locate)
;; (global-set-key [f10] 'helm-ag)
;; (global-set-key (kbd "C-k") 'kill-line)

(global-set-key (kbd "C-c h") 'avy-goto-char)

;; Set selection faces
(custom-set-faces!
  ;; 注意前面的单引号，它采用了更简洁的键值对语法
  '(region :background "#E66" :foreground "#ffffff"))
;; more face config
;; (custom-set-faces!
;;   '(region :background "#E66" :foreground "#ffffff")
;;   '(hl-line :background "#222222")               ;; 光标所在行的背景色
;;   '(font-lock-comment-face :foreground "#888888" :slant italic)) ;; 注释颜色及斜体

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


;; ibuffer format
(after! ibuffer
  ;; nearly all of this is the default layout
  (setq ibuffer-formats
        '((mark modified read-only " "
           (name 30 30 :left :elide) ; change: 30s were originally 18s
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
          (mark " "
                (name 16 -1)
                " " filename)))

  (require 'ibuf-ext)

  ;; 隐藏烦人的内部/后台 Buffer
  ;; (add-to-list 'ibuffer-never-show-predicates "^\\*Eglot")
  ;; (add-to-list 'ibuffer-never-show-predicates "^\\*Flymake")
  ;; (add-to-list 'ibuffer-never-show-predicates "^\\*Async")
  ;; (add-to-list 'ibuffer-never-show-predicates "^\\*Warnings")
  ;; (add-to-list 'ibuffer-never-show-predicates "^\\*Backtrace")
  ;; (add-to-list 'ibuffer-never-show-predicates "^\\*Copilot")
  ;; 如果你够狠，甚至可以隐藏除了 scratch 和 Messages 之外的所有星号 buffer

  ;; 定义你专属的分类逻辑
  (setq ibuffer-saved-filter-groups
        '(("Default"
           ;; 1. 核心配置文件
           ("Emacs Config" (filename . ".config/doom"))
           ;; 2. 前端/Web 框架开发
           ("Docusaurus" (or (filename . "website")
                             (mode . typescript-mode)
                             (mode . js-mode)))
           ;; 3. 语言与工具
           ("LaTeX Docs" (mode . latex-mode))
           ("C/C++" (or (mode . c-mode) (mode . c++-mode)))
           ;; 4. 系统管理与 Git
           ("Magit" (name . "^magit"))
           ("Dired" (mode . dired-mode))
           ;; 5. 兜底的临时文件
           ("Org/Notes" (mode . org-mode)))))

  ;; 让 ibuffer 启动时强制加载这套分组
  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "Default")))
  )
;; Enable icons in ibuffer
(use-package! nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

;; chatgpt-shell config
;; A function to merge two lists, where the second list's content is appended to the first list.
(defun merge-list-to-list (dst src)
  "Merges content of the 2nd list(SRC) with the 1st one(DST)."
  (set dst
       (append (eval dst) src)))

(use-package! chatgpt-shell
  :defer t
  :config
  ;; Define API keys for different providers (OpenAI, DeepSeek, Google Gemini, Anthropic)
  ;; (setq chatgpt-shell-openai-key (getenv "OPENAI_API_KEY")) ;; not working anymore!
  (setq chatgpt-shell-deepseek-key (getenv "DEEPSEEK_API_KEY"))
  (setq chatgpt-shell-google-key (getenv "GEMINI_API_KEY"))
  ;; (setq chatgpt-shell-anthropic-key (getenv "ANTHROPIC_API_KEY")) ;; not working anymore!

  ;; 设定一个硬核的 System Prompt (提升 AI 输出的信噪比)
  (setq chatgpt-shell-system-prompt
        "You are an expert AI assistant and senior developer.
Provide concise, accurate, and direct answers without unnecessary pleasantries.
Output code in clean blocks.")

  (require 'ob-chatgpt-shell)
  (ob-chatgpt-shell-setup)

  ;; other config
  ;; (merge-list-to-list 'chatgpt-shell-model-versions
  ;;                     '("gpt-3.5-turbo-16k-0613"
  ;;                       "gpt-3.5-turbo-1106"))
  ;; (add-to-list 'chatgpt-shell-model-versions "gpt-3.5-turbo-1106")
  ;; (setq chatgpt-shell-additional-curl-options "https://192.168.6.1:10809")
  )

;; company config
;; ========================================================
;; 1. Company 核心与 TNG (Tab-and-Go) 配置
;; ========================================================
(after! company
  ;; 【核心】：调用 Company 官方的 TNG 初始化函数，彻底接管 TAB 和 RET 键
  ;; 实现真正的“Tab选中并虚拟上屏，继续输入即确认，回车只负责换行”
  (company-tng-mode)

  ;; 基础参数调优
  (setq company-idle-delay 0.1                 ;; 触发延迟极速版
        company-minimum-prefix-length 2        ;; 输入2个字符即触发
        company-selection-wrap-around t        ;; 列表循环滚动
        company-require-match 'never           ;; 允许输入非补全项内容
        company-show-quick-access t            ;; ✨ 使用最新版变量：在候选项旁显示 1-0 数字快捷键
        company-tooltip-limit 12)              ;; 限制最大显示候选项数量

  ;; 视觉弹窗设置 (配合 init.el 中的 +childframe)
  (when (modulep! :completion company +childframe)
    (after! company-box
      (setq company-box-doc-delay 0.5))))      ;; 停留0.5秒后自动弹出文档侧边栏

;; ========================================================
;; 2. Eglot 与 Company 完美融合配置
;; ========================================================
(after! eglot
  ;; 必须使用 Hook，确保仅在 Eglot 激活的 Buffer 内部修改补全后端，避免污染全局或引发 JSON 解析错误
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              ;; 混合后端：将 Eglot原生补全 (capf)、代码片段 (yasnippet) 和当前文件内单词 (dabbrev) 绑在一起
              (setq-local company-backends
                          '((company-capf :with company-yasnippet company-dabbrev-code)))
              ;; 确保 LSP 模式下弹窗速度与全局保持一致
              (setq-local company-idle-delay 0.1)
              ;; enable auto format when save buffer.
              ;; 将 eglot-format-buffer 挂载到保存前的触发器上
              ;; 参数解释：
              ;; nil: 不指定特殊的执行优先级
              ;; t:   【核心机制】将这个 hook 设置为 Buffer-Local（仅当前文件生效）
              (add-hook 'before-save-hook #'eglot-format-buffer nil t)
              )))

;; ;;
;; (after! eglot
;;   (add-hook 'eglot-managed-mode-hook
;;             (lambda ()
;;               ;; 将 eglot-format-buffer 挂载到保存前的触发器上
;;               ;; 参数解释：
;;               ;; nil: 不指定特殊的执行优先级
;;               ;; t:   【核心机制】将这个 hook 设置为 Buffer-Local（仅当前文件生效）
;;               (add-hook 'before-save-hook #'eglot-format-buffer nil t))))

;; corfu config
;; (after! corfu
;;   ;; 1. 基础行为微调
;;   (setq corfu-auto t                 ;; 开启自动触发
;;         corfu-auto-delay 0.1         ;; 将延迟从默认的 0.2 缩短到 0.1 秒，手感更连贯
;;         corfu-auto-prefix 2          ;; 输入 2 个字符后就开始补全 (默认是 3)
;;         corfu-quit-no-match t        ;; 当没有任何匹配项时，立刻关闭弹窗，不遮挡视线
;;         corfu-quit-at-boundary t     ;; 当遇到单词边界（如空格）时退出补全
;;         corfu-preselect 'prompt)     ;; 【防误触核心】默认不自动选中第一个候选项！必须手动用方向键或 TAB 选定，这样按回车时才会上屏，否则就是普通换行。

;;   ;; 2. 开启文档弹窗 (Eglot 神器)
;;   ;; 当你在候选项上停留时，自动在一个旁边的悬浮窗里显示该函数/变量的完整文档说明。
;;   (corfu-popupinfo-mode 1)
;;   (setq corfu-popupinfo-delay '(0.5 . 0.2)) ;; 停留 0.5 秒后显示文档

;;   ;; 3. 记忆历史选择
;;   ;; 让 Corfu 记住你最常选的词汇，下次它们会排在补全列表的最前面
;;   (corfu-history-mode 1)

;;   ;; 4. 优化快捷键映射：类似 VS Code 的 Tab-and-Go 体验
;;   (map! :map corfu-map
;;         ;; 使用 TAB / S-TAB 在补全列表中上下穿梭
;;         "TAB"        #'corfu-next
;;         [tab]        #'corfu-next
;;         "S-TAB"      #'corfu-previous
;;         [backtab]    #'corfu-previous
;;         ;; 按下回车确认选中项
;;         "RET"        #'corfu-insert
;;         [return]     #'corfu-insert
;;         ;; 在文档弹窗中上下滚动 (不离开补全列表)
;;         "M-p"        #'corfu-popupinfo-scroll-down
;;         "M-n"        #'corfu-popupinfo-scroll-up))

;; (use-package! cape
;;   :init
;;   ;; 在默认的补全函数列表中加入普通文本单词和文件路径的补全能力
;;   (add-to-list 'completion-at-point-functions #'cape-dabbrev)
;;   (add-to-list 'completion-at-point-functions #'cape-file))

;; ;; 【可选】将 Eglot 和普通单词混合补全
;; ;; 如果你希望在写代码时，Eglot 的提示和文件内的普通单词提示同时出现，可以挂载这个钩子：
;; (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)

;; org mode settings
;; (after! org
;;   (setq org-log-done t
;;         org-startup-folded t
;;         ;; org-ai-mode t
;;         ;; org-ai-global-mode t
;;         org-use-property-inheritance t
;;         org-confirm-babel-evaluate nil
;;         org-list-allow-alphabetical t
;;         org-export-with-sub-superscripts nil
;;         org-export-headline-levels 5
;;         org-export-use-babel t
;;         org-use-speed-commands t
;;         org-return-follows-link t
;;         org-hide-emphasis-markers t
;;         org-special-ctrl-a/e t
;;         org-special-ctrl-k t
;;         org-src-preserve-indentation nil
;;         org-src-tab-acts-natively t
;;         org-src-content-indentation 0
;;         org-export-in-background nil
;;         org-fontify-quote-and-verse-blocks t
;;         org-fontify-whole-heading-line t
;;         org-fontify-done-headline t
;;         org-support-shift-select t      ; Enable shift selection.
;;         org-fold-catch-invisible-edits 'smart)
;;   (setq org-ellipsis " ▾ "
;;         org-hide-leading-stars t
;;         org-priority-highest ?A
;;         org-priority-lowest ?E
;;         org-priority-faces
;;         '((?A . 'all-the-icons-red)
;;           (?B . 'all-the-icons-orange)
;;           (?C . 'all-the-icons-yellow)
;;           (?D . 'all-the-icons-green)
;;           (?E . 'all-the-icons-blue)))
;;   (setq-default prettify-symbols-alist
;;                 '(("#+title:" . "✍")
;;                   ("#+author:" . "👨")
;;                   ;; ("#+caption:" . "☰")
;;                   ("#+RESULTS:" . "🎁")
;;                   ("#+header:" . "󱍞")
;;                   ;; ("#+attr_latex:" . "🍄")
;;                   ;; ("#+attr_org:" . "🔔")
;;                   ;; ("#+date:" . "⚓")
;;                   ;; ("#+property:" . "☸")
;;                   ("#+OPTIONS:" . "⌥")
;;                   ("#+options:" . "⌥")
;;                   ("$+name:" . "㊔")
;;                   (":PROPERTIES:" . "⚙")
;;                   (":file" . "")
;;                   (":results" . "")
;;                   (":exports" . "󰮓")
;;                   ;; (":END:" . ".")
;;                   ;; ("[ ]" . "󰄮")
;;                   ;; ("[X]" . "")
;;                   ;; ("\\pagebreak" . 128204)
;;                   ;; ("#+begin_quote" . "❮")
;;                   ;; ("#+end_quote" . "❯")
;;                   ;; ("#+BEGIN_Highlight" . "📖")
;;                   ;; ("#+END_Highlight" . "📜")
;;                   ("#+begin_src" . "⏩")
;;                   ("#+end_src" . "⏪")))
;;   (org-babel-do-load-languages
;;    'org-babel-load-languages
;;    '((gnuplot . t)
;;      (latex . t)
;;      (asymptote . t)
;;      (R . t)
;;      (org . t)
;;      (js . t)
;;      (emacs-lisp . t)
;;      (calc . t)
;;      ;; (ruby . t)
;;      )
;;    )
;;   (defun my-insert-and-move ()
;;     (interactive)
;;     (insert " $$ ")
;;     (backward-char 2))
;;   (add-hook 'org-mode-hook
;;             (lambda ()
;;               (local-set-key (kbd "$") 'my-insert-and-move)))
;;   (add-hook 'org-mode-hook (lambda ()
;;                              (org-superstar-mode 1)
;;                              (org-modern-mode -1)
;;                              ;; (org-ai-global-mode 1)
;;                              ;; (org-ai-mode 1)
;;                              (org-special-block-extras-mode 1)
;;                              ))
;;   (setq org-list-demote-modify-bullet
;;         (quote (("+" . "-")
;;                 ("-" . "+")
;;                 ("*" . "-")
;;                 ("1." . "1)")
;;                 ("1)" . "A.")
;;                 ("A." . "a)")
;;                 ("a)" . "a.")
;;                 ("a." . "*")
;;                 ("b." . "*"))))
;;   (setq org-superstar-item-bullet-alist
;;         '((?* . ?➤)
;;           (?+ . ?✦)
;;           (?- . ?⚘)))
;;   (defface my-org-emphasis-bold
;;     '((default :inherit bold)
;;       (((class color) (min-colors 88) (background light))
;;        :foreground "#a60000")
;;       (((class color) (min-colors 88) (background dark))
;;        :foreground "#ff8059"))
;;     "My bold emphasis for Org.")

;;   (defface my-org-emphasis-bold-1
;;     '((default :inherit bold)
;;       (((class color) (min-colors 88) (background light))
;;        :foreground "#a60000")
;;       (((class color) (min-colors 88) (background dark))
;;        :background "#f00059"))
;;     "My bold emphasis for Org.")

;;   (defface my-org-emphasis-italic
;;     '((default :inherit italic)
;;       (((class color) (min-colors 88) (background light))
;;        :foreground "#005e00")
;;       (((class color) (min-colors 88) (background dark))
;;        :foreground "#44bc44"))
;;     "My italic emphasis for Org.")

;;   (defface my-org-emphasis-underline
;;     '((default :inherit underline)
;;       (((class color) (min-colors 88) (background light))
;;        :foreground "#813e00")
;;       (((class color) (min-colors 88) (background dark))
;;        :foreground "#d0bc00"))
;;     "My underline emphasis for Org.")

;;   (defface my-org-emphasis-strike-through
;;     '((((class color) (min-colors 88) (background light))
;;        :strike-through "#972500" :foreground "#505050")
;;       (((class color) (min-colors 88) (background dark))
;;        :strike-through "#ef2b50" :foreground "#a8a8a8"))
;;     "My strike-through emphasis for Org.")

;;   (setq org-emphasis-alist
;;         '(("*" my-org-emphasis-bold-1)
;;           ("/" my-org-emphasis-italic)
;;           ("_" my-org-emphasis-underline)
;;           ("=" org-verbatim verbatim)
;;           ("~" org-code verbatim)
;;           ("+" my-org-emphasis-strike-through)))

;;   (require 'org-extra-emphasis)

;;   ;; (custom-set-variables
;;   ;;  '(org-extra-emphasis-alist
;;   ;;    '(("<kbd>" org-extra-emphasis-01)
;;   ;;      ))
;;   ;;  '(org-hide-emphasis-markers t))

;;   ;; (custom-set-faces
;;   ;;  '(org-extra-emphasis-01
;;   ;;    ((t (:background "yellow"
;;   ;;         :foreground "black"
;;   ;;         :box (:line-width (1 . 1)
;;   ;;               :color "red"
;;   ;;               :style None)
;;   ;;         )))))

;;   (setq org-src-block-faces
;;         '(
;;           ("emacs-lisp" (:background "#11526F"))
;;           ("python" (:background "#E5FFB8"))
;;           ))

;;   (progn
;;     (setq org-src-lang-modes
;;           (append org-src-lang-modes
;;                   '(
;;                     ("R" . ess-r)
;;                     ("js" . js2)
;;                     ))))

;;   (require 'org-tempo)
;;   (add-to-list 'org-structure-template-alist
;;                '("d" . "details Hint"))
;;   (add-to-list 'org-structure-template-alist
;;                '("b" . "box"))

;;   ;; (add-to-list 'company-backends 'company-capf)
;;   (add-hook 'org-mode-hook
;;             (lambda ()
;;               (add-hook 'after-save-hook 'org-babel-tangle nil 'make-it-local)))

;;   (require 'org-download)
;;   ;; Drag-and-drop to `dired`
;;   ;; If you have the image stored in the clipboard, use org-download-clipboard.
;;   (add-hook 'dired-mode-hook 'org-download-enable)
;;   (add-hook 'org-mode-hook 'rainbow-mode)

;;   ;; (require 'ob-chatgpt-shell)
;;   ;; (ob-chatgpt-shell-setup)
;;   )

;;   org mode setup optimize
(after! org
  (setq org-log-done t
        org-startup-folded t
        org-use-property-inheritance t
        org-confirm-babel-evaluate nil
        org-list-allow-alphabetical t
        org-export-with-sub-superscripts nil
        org-export-headline-levels 5
        org-export-use-babel t
        org-use-speed-commands t
        org-return-follows-link t
        org-hide-emphasis-markers t
        org-special-ctrl-a/e t
        org-special-ctrl-k t
        org-src-preserve-indentation nil
        org-src-tab-acts-natively t
        org-src-content-indentation 0
        org-export-in-background nil
        org-fontify-quote-and-verse-blocks t
        org-fontify-whole-heading-line t
        org-fontify-done-headline t
        org-support-shift-select t
        org-fold-catch-invisible-edits 'smart
        org-ellipsis " ▾ "
        org-hide-leading-stars t
        org-priority-highest ?A
        org-priority-lowest ?E
        org-priority-faces
        '((?A . 'all-the-icons-red)
          (?B . 'all-the-icons-orange)
          (?C . 'all-the-icons-yellow)
          (?D . 'all-the-icons-green)
          (?E . 'all-the-icons-blue)))

  ;; 1. 现代优化：在 Doom / Emacs 30 中建议直接将 prettify 注入 hook
  (setq-default prettify-symbols-alist
                '(("#+title:" . "✍")
                  ("#+author:" . "👨")
                  ("#+RESULTS:" . "🎁")
                  ("#+header:" . "󱍞")
                  ("#+OPTIONS:" . "⌥")
                  ("#+options:" . "⌥")
                  ("$+name:" . "㊔")
                  (":PROPERTIES:" . "⚙")
                  (":file" . "")
                  (":results" . "")
                  (":exports" . "󰮓")
                  ("#+begin_src" . "⏩")
                  ("#+end_src" . "⏪")))

  ;; 2. 健壮性：延迟或按需加载 languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((gnuplot . t)
     (latex . t)
     (asymptote . t)
     (R . t)
     (org . t)
     (js . t)
     (emacs-lisp . t)
     (calc . t)))

  ;; 3. 规范化：移除匿名 lambda 钩子，避免由于多此重复加载配置导致内存泄漏/按键重复
  (defun my-org-mode-setup-bindings-h ()
    "Setup local keybindings for org-mode."
    (local-set-key (kbd "$") #'my-insert-and-move))

  (defun my-insert-and-move ()
    "Insert ' $$ ' and step inside."
    (interactive)
    (insert " $$ ")
    (backward-char 2))

  (add-hook 'org-mode-hook #'my-org-mode-setup-bindings-h)

  (defun my-org-mode-plugins-h ()
    "Enable/Disable required minor modes for org."
    (org-superstar-mode 1)
    (org-modern-mode -1)
    (org-special-block-extras-mode 1)
    (rainbow-mode 1))

  (add-hook 'org-mode-hook #'my-org-mode-plugins-h)

  (setq org-list-demote-modify-bullet
        '(("+" . "-")
          ("-" . "+")
          ("*" . "-")
          ("1." . "1)")
          ("1)" . "A.")
          ("A." . "a)")
          ("a)" . "a.")
          ("a." . "*")
          ("b." . "*")))

  (setq org-superstar-item-bullet-alist
        '((?* . ?➤)
          (?+ . ?✦)
          (?- . ?⚘)))

  ;; 4. 修复 Flycheck 报错：添加 :group 'org-faces 属性
  (defface my-org-emphasis-bold
    '((default :inherit bold)
      (((class color) (min-colors 88) (background light)) :foreground "#a60000")
      (((class color) (min-colors 88) (background dark))  :foreground "#ff8059"))
    "My bold emphasis for Org."
    :group 'org-faces)

  (defface my-org-emphasis-bold-1
    '((default :inherit bold)
      (((class color) (min-colors 88) (background light)) :foreground "#a60000")
      (((class color) (min-colors 88) (background dark))  :background "#f00059"))
    "My bold emphasis for Org-1."
    :group 'org-faces)

  (defface my-org-emphasis-italic
    '((default :inherit italic)
      (((class color) (min-colors 88) (background light)) :foreground "#005e00")
      (((class color) (min-colors 88) (background dark))  :foreground "#44bc44"))
    "My italic emphasis for Org."
    :group 'org-faces)

  (defface my-org-emphasis-underline
    '((default :inherit underline)
      (((class color) (min-colors 88) (background light)) :foreground "#813e00")
      (((class color) (min-colors 88) (background dark))  :foreground "#d0bc00"))
    "My underline emphasis for Org."
    :group 'org-faces)

  (defface my-org-emphasis-strike-through
    '((((class color) (min-colors 88) (background light)) :strike-through "#972500" :foreground "#505050")
      (((class color) (min-colors 88) (background dark))  :strike-through "#ef2b50" :foreground "#a8a8a8"))
    "My strike-through emphasis for Org."
    :group 'org-faces)

  (setq org-emphasis-alist
        '(("*" my-org-emphasis-bold-1)
          ;; 密级标记
          ("/" my-org-emphasis-italic)
          ("_" my-org-emphasis-underline)
          ("=" org-verbatim verbatim)
          ("~" org-code verbatim)
          ("+" my-org-emphasis-strike-through)))

  ;; 5. 健壮性：使用 Doom 推荐的内置 feature 结构进行扩展模块防爆加载
  (after! org-extra-emphasis
    ;; 如果需要覆盖变量，在对应包加载后进行
    )

  (setq org-src-block-faces
        '(("emacs-lisp" (:background "#11526F"))
          ("python" (:background "#E5FFB8"))))

  ;; 6. 性能：放弃（容易导致重复 append 的）append，直接覆盖或用 add-to-list
  (setq org-src-lang-modes
        (append org-src-lang-modes
                '(("R" . ess-r)
                  ("js" . js2))))

  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("d" . "details Hint"))
  (add-to-list 'org-structure-template-alist '("b" . "box"))

  ;; 7. 规范化：将自动纠缠、多模式使能等逻辑绑定到解耦的 Hook 函数中
  (defun my-org-mode-save-hook-setup-h ()
    "Setup buffer local after-save-hook for babel tangling."
    (add-hook 'after-save-hook #'org-babel-tangle nil 'local))

  (add-hook 'org-mode-hook #'my-org-mode-save-hook-setup-h)

  (with-eval-after-load 'dired
    (require 'org-download)
    (add-hook 'dired-mode-hook #'org-download-enable)))

;; ox-hugo config
(after! ox
  (require 'ox-hugo))


;; (require 'pyim-basedict) ; 拼音词库设置，五笔用户 *不需要* 此行设置
;; (pyim-basedict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置
(after! pyim
  (setq pyim-page-tooltip 'popup)
  (setq pyim-cloudim 'baidu)
  (pyim-isearch-mode 1)
  )
(after! pyim-basedict
  (pyim-basedict-enable))
(after! pyim-tsinghua-dict
  (pyim-tsinghua-dict-enable))

;; (with-eval-after-load "liberime"
;;   (liberime-try-select-schema "luna_pinyin_simp")
;;   (setq pyim-default-scheme 'rime-quanpin))

(use-package! rime
  :config
  ;; 1. 设置 Emacs 的默认输入法为 RIME
  (setq-default default-input-method "rime")

  ;; 2. 其余配置保持在 :config 块中安全执行
  (setq rime-inline-ascii-trigger 'caron)

  ;; 3. 精准指向你已经配置好、并且没有锁死文件的 RIME 目录
  (setq rime-user-data-dir "~/.config/emacs/.local/cache/rime/")

  ;; 4. 优化断言：解决部分 Linux 环境下 Zsh 环境变量引起的 RIME 编译探测冲突
  (setq rime-librime-paths '("/usr/lib/librime.so" "/usr/local/lib/librime.so"))

  ;; 5. 绑定快捷键：在任何模式下按 C-\ 即可一键自由切换中英文输入状态
  ;; (global-set-key (kbd "C-\\") #'toggle-input-method)
  )

;; ----------------------------------------------------------------------------
;; ESS related customization
(after! ess
  ;; (add-hook! 'prog-mode-hook #'rainbow-delimiters-mode)
  (add-hook! 'prog-mode-hook #'rainbow-mode)

  ;; combines https://github.com/fernandomayer/spacemacs/blob/master/private/ess/packages.el and
  ;; https://github.com/MilesMcBain/spacemacs_cfg/blob/master/private/ess/packages.el.
  ;;
  ;; This is a little fishy because it relies on lazy-loading, because
  ;; +keybindings.el already loaded at the top of this file and there this
  ;; function is called.
  (defun tide-insert-pipe ()
    "Insert a %>%"
    (interactive)
    (unless (looking-back "%>%" nil)
      (just-one-space 1)
      (insert "%>% "))
    (newline-and-indent)
    )
  (defun tide-insert-in ()
    "Insert a %in%"
    (interactive)
    (unless (looking-back "%in%" nil)
      (just-one-space 1)
      (insert "%in% "))
    ;; (newline-and-indent)
    )
  (defun tide-insert-plus ()
    "Insert a %+%"
    (interactive)
    (unless (looking-back "%+%" nil)
      (just-one-space 1)
      (insert "%+% "))
    ;; (newline-and-indent)
    )
  (defun tide-insert-assign ()
    "Insert a <-"
    (interactive)
    (unless (looking-back "<-" nil)
      (just-one-space 1)
      (insert "<-"))
    ;; (newline-and-indent)
    )
  (defun tide-insert-base-pipe ()
    "Insert a |>"
    (interactive)
    (unless (looking-back "|>" nil)
      (just-one-space 1)
      (insert "|>"))
    ;; (newline-and-indent)
    )

  ;; If I use LSP it is better to let LSP handle lintr. See example in
  ;; https://github.com/hlissner/doom-emacs/issues/2606.
  (setopt ess-use-flymake nil)
  (setopt lsp-ui-doc-enable nil
          lsp-ui-doc-delay 1.5)

  ;; Code indentation copied from my old config.
  ;; Follow Hadley Wickham's R style guide
  (setq
   ess-style 'RStudio
   ess-offset-continued 2
   ess-expression-offset 0)

  (setq comint-move-point-for-output t)

  ;; From https://emacs.readthedocs.io/en/latest/ess__emacs_speaks_statistics.html
  ;; TODO: find out a way to make settings generic so that I can also set ess-inf-R-font-lock-keywords
  (setq ess-R-font-lock-keywords
        '((ess-R-fl-keyword:modifiers  . t)
          (ess-R-fl-keyword:fun-defs   . t)
          (ess-R-fl-keyword:keywords   . t)
          (ess-R-fl-keyword:assign-ops . t)
          (ess-R-fl-keyword:constants  . t)
          (ess-fl-keyword:fun-calls    . t)
          (ess-fl-keyword:numbers      . t)
          (ess-fl-keyword:operators    . t)
          ;; (ess-fl-keyword:delimiters) ; don't because of rainbow delimiters
          (ess-fl-keyword:=            . t)
          (ess-R-fl-keyword:F&T        . t)
          (ess-R-fl-keyword:%op%       . t)))

  ;; ESS buffers should not be cleaned up automatically
  ;; (add-hook 'inferior-ess-mode-hook #'doom-mark-buffer-as-real-h)

  ;; Open ESS R window to the left iso bottom.
  (set-popup-rule! "^\\*R.*\\*$" :side 'left :size 0.38 :select nil :ttl nil :quit nil :modeline t)
  )

;; doesn't work!
;; (use-package! ess-view-data)


;; Ways to disable smartparens for specific characters or fully in a mode.
;; https://github.com/hlissner/doom-emacs/issues/576
;; (after! smartparens
;;   ;; this pair change below does not work as good as just disabling overall
;;   ;; (which i seem to prefer anyway)
;;   ;; (sp-with-modes 'markdown-mode
;;   ;;   (sp-local-pair "`" nil))
;;   ;; (add-hook 'ess-r-mode-hook    #'turn-off-smartparens-mode)
;;   (add-hook 'markdown-mode-hook #'turn-off-smartparens-mode))

;; ----------------------------------------------------------------------------
(map!
 (:after dired
         (:map dired-mode-map
               "r" #'wdired-change-to-wdired-mode))
 (:after ess
         (:map ess-r-mode-map
               "_" #'ess-insert-assign
               "C-c ." #'tide-insert-pipe
               "C-c ," #'tide-insert-in
               "C-c /" #'tide-insert-plus
               "C-c \\" #'tide-insert-base-pipe
               ;; :i     "M--" #'ess-insert-assign
               ;; :i     "M--" #'tide-insert-assign
               ;; :i     "M-+" #'tide-insert-pipe
               ;; :i     "M-p" #'tide-insert-pipe
               ;; :i     "RET" #'ess-indent-new-comment-line
               )

         (:map inferior-ess-r-mode-map
               "_" #'ess-insert-assign
               "C-c ." #'tide-insert-pipe
               "C-c ," #'tide-insert-in
               "C-c /" #'tide-insert-plus
               "C-c \\" #'tide-insert-base-pipe
               ;; :nvio  "C-k" #'comint-previous-input
               ;; :nvio  "C-j" #'comint-next-input
               ;; :i     "M-+" #'tide-insert-pipe
               ;; :i     "M-p" #'tide-insert-pipe
               ;; :i     "M--" #'tide-insert-assign
               ;; :i     "M--" #'ess-insert-assign
               ))
 )

;; some settings for calendar and cal-china-x
(use-package! cal-china-x
  :after calendar
  :autoload cal-china-x-setup
  :init (cal-china-x-setup)
  :config
  (setq calendar-week-start-day 1
        calendar-mark-holidays-flag t
        ;; Below setting doesn't work. [2025-02-27]
        ;; cal-china-x-important-holidays cal-china-x-chinese-holidays
        )
  (setq calendar-intermonth-text
        '(propertize
          (format "%2d"
                  (car
                   (calendar-iso-from-absolute
                    (calendar-absolute-from-gregorian (list month day year)))))
          'font-lock-face 'font-lock-warning-face))
  (setq calendar-intermonth-header
        (propertize "Wk"                  ; or e.g. "KW" in Germany
                    'font-lock-face 'font-lock-keyword-face))
  )

;; Mark weekends days with a different color.

;; 1. 定义一个独立的 Advice 函数
(defun my-calendar-highlight-weekends (month year _indent)
  "After generating the calendar MONTH and YEAR, highlight weekend days."
  ;; 获取当前月准确的总天数（自动处理 2 月和闰年）
  (let ((last-day (calendar-last-day-of-month month year)))
    (dotimes (i last-day)
      (let ((date (list month (1+ i) year)))
        (if (or (= (calendar-day-of-week date) 0)   ; 0 代表周日
                (= (calendar-day-of-week date) 6))  ; 6 代表周六
            (calendar-mark-visible-date date 'font-lock-doc-string-face))))))

;; 2. 使用符合 Emacs 30 标准的 advice-add 将其挂载为 :after 类型的钩子
(advice-add 'calendar-generate-month :after #'my-calendar-highlight-weekends)


;; (after! elfeed
;;   :config
;;   (setopt elfeed-curl-timeout 180)
;;   (defun elfeed-goodies/search-header-draw ()
;;     "Returns the string to be used as the Elfeed header."
;;     (if (zerop (elfeed-db-last-update))
;;         (elfeed-search--intro-header)
;;       (let* ((separator-left (intern (format "powerline-%s-%s"
;;                                              elfeed-goodies/powerline-default-separator
;;                                              (car powerline-default-separator-dir))))
;;              (separator-right (intern (format "powerline-%s-%s"
;;                                               elfeed-goodies/powerline-default-separator
;;                                               (cdr powerline-default-separator-dir))))
;;              (db-time (seconds-to-time (elfeed-db-last-update)))
;;              (stats (-elfeed/feed-stats))
;;              (search-filter (cond
;;                              (elfeed-search-filter-active
;;                               "")
;;                              (elfeed-search-filter
;;                               elfeed-search-filter)
;;                              (""))))
;;         (if (>= (window-width) (* (frame-width) elfeed-goodies/wide-threshold))
;;             (search-header/draw-wide separator-left separator-right search-filter stats db-time)
;;           (search-header/draw-tight separator-left separator-right search-filter stats db-time)))))

;;   (defun elfeed-goodies/entry-line-draw (entry)
;;     "Print ENTRY to the buffer."

;;     (let* ((title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
;;            (date (elfeed-search-format-date (elfeed-entry-date entry)))
;;            (author (plist-get (nth 0 (elfeed-meta entry :authors)) :name))
;;            (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
;;            (feed (elfeed-entry-feed entry))
;;            (feed-title
;;             (when feed
;;               (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
;;            (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
;;            (tags-str (concat "[" (mapconcat 'identity tags ",") "]"))
;;            (title-width (- (window-width) elfeed-goodies/feed-source-column-width
;;                            elfeed-goodies/tag-column-width 4))
;;            (author-column (elfeed-format-column
;;                            author (elfeed-clamp (length author)
;;                                                 elfeed-goodies/feed-source-column-width
;;                                                 elfeed-goodies/feed-source-column-width)
;;                            :left))
;;            (title-column (elfeed-format-column
;;                           title (elfeed-clamp
;;                                  elfeed-search-title-min-width
;;                                  title-width
;;                                  title-width)
;;                           :left))
;;            (tag-column (elfeed-format-column
;;                         tags-str (elfeed-clamp (length tags-str)
;;                                                elfeed-goodies/tag-column-width
;;                                                elfeed-goodies/tag-column-width)
;;                         :left))
;;            (feed-column (elfeed-format-column
;;                          feed-title (elfeed-clamp elfeed-goodies/feed-source-column-width
;;                                                   elfeed-goodies/feed-source-column-width
;;                                                   elfeed-goodies/feed-source-column-width)
;;                          :left)))

;;       (if (>= (window-width) (* (frame-width) elfeed-goodies/wide-threshold))
;;           (progn
;;             (insert (propertize date 'face 'elfeed-search-date-face) " ")
;;             (insert (propertize feed-column 'face 'elfeed-search-feed-face) " ")
;;             (insert (propertize tag-column 'face 'elfeed-search-tag-face) " ")
;;             (insert (propertize author-column 'face 'elfeed-search-author-face) " ")
;;             (insert (propertize title 'face title-faces 'kbd-help title)))
;;         (insert (propertize title 'face title-faces 'kbd-help title)))))

;;   ;; to sort by title.
;;   ;; (setq elfeed-search-sort-function
;;   ;;       (lambda (a b)
;;   ;;         (string> (downcase (elfeed-entry-title a))
;;   ;;                  (downcase (elfeed-entry-title b)))))

;;   ;; A flag to indicate the current sort mode.
;;   (defvar my/elfeed-sort-by-title-p nil
;;     "Non-nil if Elfeed search results are currently sorted by title.")

;;   (defun my/elfeed-toggle-sort ()
;;     "Toggle sorting of Elfeed search results between title and default (date)."
;;     (interactive)
;;     (if my/elfeed-sort-by-title-p
;;         (progn
;;           (setq elfeed-search-sort-function nil) ; revert to default (date) sorting
;;           (setq my/elfeed-sort-by-title-p nil)
;;           (message "Sorting by date (default)"))
;;       (setq elfeed-search-sort-function
;;             (lambda (a b)
;;               (string> (downcase (elfeed-entry-title a)) ;; < in ascending, and > in descending
;;                        (downcase (elfeed-entry-title b)))))
;;       (setq my/elfeed-sort-by-title-p t)
;;       (message "Sorting by title"))
;;     ;; Update the search buffer to reflect the new sort.
;;     (elfeed-search-update t))

;;   ;; Bind "t" in elfeed-search-mode to toggle sorting.
;;   (with-eval-after-load 'elfeed-search
;;     (define-key elfeed-search-mode-map (kbd "t") #'my/elfeed-toggle-sort))

;;   ;; Somewhere in your .emacs file
;;   ;; (setq elfeed-feeds
;;   ;;       '("http://nullprogram.com/feed/"
;;   ;; "https://planet.emacslife.com/atom.xml"))
;;   )

;; (after! elfeed-org
;;   (elfeed-org)
;;   (setq rmh-elfeed-org-files (list "~/myproj/org/elfeed.org")))

;; (use-package! elfeed
;;   (setq elfeed-feeds
;;         '("http://nullprogram.com/feed/"
;; "https://planet.emacslife.com/atom.xml")))

;; setup magit
(after! magit
  (setq magit-diff-hide-trailing-cr-characters t)
  )

;; setup latex mode
;; Enable forward/reverse search for zathura
;; (after! latex
;;   ;; use Ctrl+Mouse-1 to search.
;;   (setq auto-mode-alist (cons '("\\.latex$" . latex-mode) auto-mode-alist))
;;   ;; (add-hook 'plain-TeX-mode-hook 'LaTeX-mode)
;;   (add-hook 'plain-TeX-mode-hook (lambda ()
;;                                    (LaTeX-mode)
;;                                    ))
;;   ;; (LaTeX-mode)
;;   (add-to-list 'TeX-view-program-list '("zathura" zathura-forward-search))
;;   (define-key! TeX-mode-map "$" #'math-delimiters-insert)
;;   (define-key! LaTeX-mode-map "$" #'math-delimiters-insert)
;;   (define-key! org-mode-map "$" #'math-delimiters-insert)
;;   (define-key! cdlatex-mode-map "$" nil)
;;   ;; (add-hook! 'LaTeX-mode-hook 'LaTeX-math-mode)
;;   (define-key! LaTeX-mode-map "\\" #'TeX-insert-macro)
;;   (define-key! TeX-mode-map "\\" #'TeX-insert-macro)
;;   (setopt LaTeX-math-abbrev-prefix "~")

;;   (with-eval-after-load 'cdlatex
;;     (setq cdlatex-math-symbol-alist
;;           '((?. ("\\cdot" "\\ldots")))))

;;   (defun mg-TeX-fold-brace ()
;;     "Hide the group in which point currently is located with \"{...}\"."
;;     (interactive)
;;     (let ((opening-brace (TeX-find-opening-brace))
;;           (closing-brace (TeX-find-closing-brace))
;;           priority ov)
;;       (if (and opening-brace closing-brace)
;;           (progn
;;             (setq priority (TeX-overlay-prioritize opening-brace closing-brace))
;;             (setq ov (make-overlay opening-brace closing-brace
;;                                    (current-buffer) t nil))
;;             (overlay-put ov 'category 'TeX-fold)
;;             (overlay-put ov 'priority priority)
;;             (overlay-put ov 'evaporate t)
;;             (overlay-put ov 'TeX-fold-display-string-spec "{...}")
;;             (TeX-fold-hide-item ov))
;;         (message "No group found"))))

;;   ;; Bind the function to C-c C-o p
;;   (eval-after-load "tex-fold"
;;     '(define-key TeX-fold-keymap "p" 'mg-TeX-fold-brace))
;;   )

;; Optimize latex mode
(after! latex
  ;; 1. 优化：使用更符合现代惯例的扩展名关联方式
  (add-to-list 'auto-mode-alist '("\\.latex$" . LaTeX-mode)) ; 注意：AUCTeX 的主模式名是大写的 LaTeX-mode

  ;; 2. 修复 Flycheck 报错：移除了多余的参数 1，并规范了钩子写法
  (add-hook 'plain-TeX-mode-hook #'LaTeX-mode)

  (add-to-list 'TeX-view-program-list '("zathura" zathura-forward-search))

  ;; 3. 优化：既然已经配置了 cdlatex 二级菜单，记得顺手同步更新到 2 of 3 的位置
  (with-eval-after-load 'cdlatex
    ;; 1. 安全地添加 TAB 快捷缩写
    (setq cdlatex-command-alist
          (append '(("tr" "Insert triangle symbol" "\\triangle " cdlatex-position-cursor nil nil t)
                    ("ag" "Insert angle symbol"    "\\angle "    cdlatex-position-cursor nil nil t))
                  cdlatex-command-alist))

    ;; 2. 安全地更新或添加反引号二级菜单，不破坏原有的 \alpha, \beta 等符号
    (setf (alist-get ?. cdlatex-math-symbol-alist)
          '("\\cdot" "\\ldots"))
    ;; 3. 精准修改斜杠（/）的 Level 1 和 Level 2
    (setf (alist-get ?/ cdlatex-math-symbol-alist)
          '("\\not" "\\parallel"))
    (setf (alist-get ?| cdlatex-math-symbol-alist)
          '("\\mapsto" "\\longmapsto" "\\perp"))
    (setf (alist-get ?c cdlatex-math-symbol-alist)
          '("" "\\circ"))
    )
  ;; (add-hook 'cdlatex-mode-hook
  ;;           (lambda ()
  ;;             ;; 强制将 TAB 和 [tab] 键绑定到 cdlatex 的补全/移动函数上
  ;;             (local-set-key (kbd "TAB") #'cdlatex-tab)
  ;;             (local-set-key (kbd "<tab>") #'cdlatex-tab)))

  ;; 4. 优化：Doom 环境下，按键绑定应优先在特定 mode-hook 或 with-eval-after-load 里执行
  (define-key! TeX-mode-map "$" #'math-delimiters-insert)
  (define-key! LaTeX-mode-map "$" #'math-delimiters-insert)
  (define-key! org-mode-map "$" #'math-delimiters-insert)
  (define-key! cdlatex-mode-map "$" nil)

  (define-key! LaTeX-mode-map "\\" #'TeX-insert-macro)
  (define-key! TeX-mode-map "\\" #'TeX-insert-macro)
  (setopt LaTeX-math-abbrev-prefix "~")

  ;; 5. 自定义折叠函数
  (defun mg-TeX-fold-brace ()
    "Hide the group in which point currently is located with \"{...}\"."
    (interactive)
    (let ((opening-brace (TeX-find-opening-brace))
          (closing-brace (TeX-find-closing-brace))
          priority ov)
      (if (and opening-brace closing-brace)
          (progn
            (setq priority (TeX-overlay-prioritize opening-brace closing-brace))
            (setq ov (make-overlay opening-brace closing-brace
                                   (current-buffer) t nil))
            (overlay-put ov 'category 'TeX-fold)
            (overlay-put ov 'priority priority)
            (overlay-put ov 'evaporate t)
            (overlay-put ov 'TeX-fold-display-string-spec "{...}")
            (TeX-fold-hide-item ov))
        (message "No group found"))))

  ;; 6. 优化：在 after! latex 内部，直接使用 with-eval-after-load 确保 tex-fold 加载后再绑定
  (with-eval-after-load 'tex-fold
    (define-key TeX-fold-keymap "p" #'mg-TeX-fold-brace))

  ;; (可选) 让 AUCTeX 自动保存文件后再编译，连按保存键都省了
  ;; (setq TeX-save-query nil)

  ;;To add a menu bar in current ’latex-mode’ buffer
  ;; Add here your personal features for ’latex-mode’:
  (with-eval-after-load 'asy-mode
    (unless (boundp 'LaTeX-verbatim-regexp)
      (setq LaTeX-verbatim-regexp "verbatim\\*?")))
  (asy-insinuate-latex t) ;; Asymptote globally insinuates Latex.
  )

(after! which-key
  (setq which-key-use-C-h-commands t)
  ;; (define-key! which-key-mode-map (kbd "C-x <f5>") 'which-key-C-h-dispatch)
  ;; (setopt which-key-paging-prefixes '("C-x"))
  ;; (setopt which-key-paging-key "<f5>")
  )

(use-package! sdcv
  :config
  ;; 1. 强行给 Emacs 注入 UTF-8 Locale 环境变量
  ;; 这会让所有被 Emacs 唤起的子进程（包括 sdcv）都知道必须用 UTF-8 解析命令行参数
  (setenv "LANG" "en_US.UTF-8")
  (setenv "LC_ALL" "en_US.UTF-8")

  ;; 2. 确保 Emacs 向系统管道发送数据时，使用纯正的 UTF-8 编码
  (setq default-process-coding-system '(utf-8 . utf-8))
  (add-to-list 'process-coding-system-alist '("sdcv" . (utf-8 . utf-8)))

  ;; 设定你的 StarDict 词典总目录
  (setq sdcv-dictionary-data-dir (expand-file-name "~/.local/share/stardict/dic"))
  ;; (setq sdcv-dictionary-data-dir "~/.local/share/stardict/dic")

  ;; 【配置简单列表】：供 sdcv-search-pointer 使用
  ;; 里面只放一本最精简的英汉词典，用于一瞥即懂的速查
  (setq sdcv-dictionary-simple-list
        '(
          "21世纪英汉汉英双向词典"
          "懒虫简明英汉词典"
          ))
  )


;; My Macros.
(defalias 'insertfootnote
  (kmacro "C-M-s M-e [ 0 - 9 ] <return> <return> C-<left> <left> C-S-<right> M-w C-M-s M-e C-y <return> <return> C-a M-x k i l l - l i n e <return> C-r s u b s e <return> C-M-s C-M-s <return> C-<left> <left> \\ f o o t n o t e { C-y <right> <right> C-S-<right> M-w C-<left> <left> C-<left> M-x r e p l a c e - s t r i n g <return> C-y <return> <return> <right> <backspace> <backspace> C-<left> <right> <delete> <left> C-<right> <right>"))

;; Some useful Funcs
(defun my-reverse-region (beg end)
  "Reverse characters between BEG and END."
  (interactive "r")
  (let ((region (buffer-substring beg end)))
    (delete-region beg end)
    (insert (nreverse region))))

;; powerthesaurus is a great online thesaurus,
;; and this package provides a convenient Emacs interface to it.
(use-package! powerthesaurus
  :bind(
        ("C-c C-d p" . powerthesaurus-lookup-dwim)
        ))

;; cape provides a collection of
;; completion-at-point-functions that can be used for completion at point.
(use-package! cape
  ;; 默认延迟加载，不拖慢启动速度
  :defer t
  :init
  ;; 1. 全局启用的通用补全源
  ;; cape-file 是极其好用的刚需，当你在字符串里输入 / 或 ~/ 时，自动补全文件路径
  (add-to-list 'completion-at-point-functions #'cape-file)

  ;; cape-dabbrev 会从当前打开的所有 Buffer 中提取单词进行补全
  ;; (注意：Company 自身已经自带了 company-dabbrev，如果你觉得重复可以注释掉这一行)
  ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)

  ;; 2. 局部启用的特定补全源 (利用 Hook 精准打击)
  ;; 只在写 Emacs Lisp 时，才启用 Elisp 符号和 Block 的补全
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (add-hook 'completion-at-point-functions #'cape-elisp-symbol nil t)
              (add-hook 'completion-at-point-functions #'cape-elisp-block nil t)))

  ;; 如果你写 LaTeX，只在 LaTeX 模式下挂载 tex 补全
  (add-hook 'latex-mode-hook
            (lambda ()
              (add-hook 'completion-at-point-functions #'cape-tex nil t))))

;; old config with global bindings for all cape functions,
;; which is a bit too much and also causes some conflicts with company-dabbrev
;; (use-package! cape
;;   ;; Bind dedicated completion commands
;;   ;; Alternative prefix keys: C-c p, M-p, M-+, ...
;;   :bind (("C-x c p" . completion-at-point) ;; capf
;;          ("C-x c t" . complete-tag)        ;; etags
;;          ("C-x c d" . cape-dabbrev)        ;; or dabbrev-completion
;;          ("C-x c h" . cape-history)
;;          ("C-x c f" . cape-file)
;;          ("C-x c k" . cape-keyword)
;;          ("C-x c s" . cape-elisp-symbol)
;;          ("C-x c e" . cape-elisp-block)
;;          ("C-x c a" . cape-abbrev)
;;          ("C-x c l" . cape-line)
;;          ("C-x c w" . cape-dict)
;;          ("C-x c :" . cape-emoji)
;;          ("C-x c \\" . cape-tex)
;;          ("C-x c _" . cape-tex)
;;          ("C-x c ^" . cape-tex)
;;          ("C-x c &" . cape-sgml)
;;          ("C-x c r" . cape-rfc1345))
;;   :init
;;   ;; Add to the global default value of `completion-at-point-functions' which is
;;   ;; used by `completion-at-point'.  The order of the functions matters, the
;;   ;; first function returning a result wins.  Note that the list of buffer-local
;;   ;; completion functions takes precedence over the global list.
;;   (add-to-list 'completion-at-point-functions #'cape-dabbrev)
;;   (add-to-list 'completion-at-point-functions #'cape-file)
;;   (add-to-list 'completion-at-point-functions #'cape-elisp-block)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-history)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-tex)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-dict)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-line)
;;   )

;; (use-package! aider
;;   :config
;;   (setq aider-args '("--model" "deepseek/deepseek-reasoner")))

;; (after! fcitx
;;   (setq fcitx-remote-command "fcitx5-remote"))

;; (after! google-translate
;;   :config
;;   (
;;    (global-set-key "\C-cg" 'google-translate-at-point)
;;    (global-set-key "\C-cG" 'google-translate-query-translate)
;;    )
;;   )

;; (use-package! aidermacs
;;   :bind  (
;;           ("C-c g" . aidermacs-transient-menu))
;;   ;; :config
;;   :custom
;;   (aidermacs-default-model "grok-beta")
;;   )

(use-package! pdffontetc
  :config
  (defun pdffontetc-extra-keys ()
    "Set some additional keybindings in PDF-Tools for pdffontetc info functions."
    ;; `O' for `Org-style' Info, = pdf metadata in orgish display:
    (local-set-key (kbd "O") #'pdffontetc-display-metadata-org-style)
    ;; `T' for `Typeface', i.e., Font info [since `F' is already taken]:
    (local-set-key (kbd "T") #'pdffontetc-display-font-information)
    ;; `U' for `Unified' info, i.e., both Metadata and Font info:
    (local-set-key (kbd "U") #'pdffontetc-display-combined-metadata-and-font-info))

  (add-hook 'pdf-view-mode-hook #'pdffontetc-extra-keys)
  )

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("M-p" . 'copilot-accept-completion)
              ;; ("TAB" . 'copilot-accept-completion)
              ;; ("C-<tab>" . 'copilot-accept-completion-by-word)
              ("M-o" . 'copilot-accept-completion-by-word))
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(clojure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
  )

;; (use-package! emms
;;   :config
;;   (require 'emms-setup)
;;   (emms-all))

;; Hooks.
(add-hook! 'emacs-lisp-mode-hook
           #'rainbow-mode
           #'flymake-mode
           )
;; (add-hook! emacs-lisp-mode #'rainbow-mode #'flymake-mode)

;; rainbow-delimiters settings
(use-package! rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (LaTeX-mode . rainbow-delimiters-mode)
         )
  :config
  (setq rainbow-delimiters-max-face-count 8)
  (setq rainbow-delimiters-outermost-only-face-count nil))

(after! rainbow-delimiters
  (defun my-rainbow-delimiters-fix-nil-depth-a (orig-fun depth match loc)
    "Prevent `rainbow-delimiters' from crashing on extreme depths.

This fixes an issue in Emacs 30 where depths greater than
`max-face-count' cause a nil depth error."
    (let ((max-faces (and (boundp 'rainbow-delimiters-max-face-count)
                          rainbow-delimiters-max-face-count)))
      ;; 如果当前深度超过了最大脸部计数，强行将计算深度限制在最大范围内
      (if (and max-faces (> depth max-faces))
          (funcall orig-fun max-faces match loc)
        (funcall orig-fun depth match loc))))

  (advice-add 'rainbow-delimiters-default-pick-face
              :around #'my-rainbow-delimiters-fix-nil-depth-a))

;; Define a function to make current window in ceter.
(defun center-column ()
  "使当前列在窗口中居中."
  (interactive)
  (let* ((win (selected-window))
         (win-width (window-width win))
         (cur-col (current-column))
         (target-pos (max 0 (- cur-col (/ win-width 2)))))
    (set-window-hscroll win target-pos)))

;; 绑定到 M-C-l（类比 C-l）
(global-set-key (kbd "M-C-l") 'center-column)

;; 同时居中行和列
(defun center-point ()
  "使光标点居中显示."
  (interactive)
  (recenter)
  (center-column))
(global-set-key (kbd "C-c -") 'center-point)

(defun consult-line-with-region ()
  "Get matched line for the selected string in current buffer."
  (interactive)
  (if (use-region-p)
      (let ((text (buffer-substring-no-properties
                   (region-beginning)
                   (region-end))))
        (deactivate-mark)
        (consult-line text))
    (consult-line)))
(global-set-key (kbd "C-c *") 'consult-line-with-region)

(after! consult
  ;; 移除了默认配置中的 -p 参数，保留 -i (忽略大小写)
  ;; 如果你想继续保持默认能搜隐藏文件，可以把 -H 也加上
  (setq consult-fd-args
        (if (executable-find "fdfind")
            "fdfind --color=never -i -u"
          "fd --color=never -i -u")))

(defun my-consult-ripgrep-at-point ()
  "在当前 Project 根目录下，搜索光标下的单词."
  (interactive)
  (let ((default-directory (or (doom-project-root) default-directory))
        (word (thing-at-point 'symbol t))) ;; 获取光标下的单词
    (consult-ripgrep nil (if word (regexp-quote word) nil))))

;; 绑定到一个方便的快捷键
;; 使用现代 Emacs 推荐的 keymap-global-set 语法
;; 将光标下的单词搜索绑定到 M-s d
(keymap-global-set "M-s d" #'my-consult-ripgrep-at-point)

(use-package! stripspace
  ;; Enable for prog-mode-hook, text-mode-hook, conf-mode-hook
  :hook ((prog-mode . stripspace-local-mode)
         (text-mode . stripspace-local-mode)
         (conf-mode . stripspace-local-mode)
         (org-mode . stripspace-local-mode)))

;; (use-package! flycheck
;;   :custom
;;   (flycheck-disable-excessive-checker '(org-lint)))

;; (with-eval-after-load 'flycheck
;;   (put 'org-lint 'flycheck-disabled t))

;; 强制将原生编译的 cache 路径也加入到 Emacs 的 Tree-sitter 探测路径中
;; (after! treesit
;;   (add-to-list 'treesit-extra-load-path
;;                (expand-file-name "~/.config/emacs/.local/cache/tree-sitter")))
(after! treesit
  (add-to-list 'treesit-extra-load-path
               (expand-file-name "~/.config/emacs/.local/cache/tree-sitter"))
  (defun my/enable-rainbow-delimiters-for-ts ()
    "从 Tree-sitter 的高亮特性中剔除 bracket 和 delimiter，从而复活 rainbow-delimiters。"
    (when (boundp 'treesit-font-lock-feature-list)
      ;; 1. 遍历当前 mode 的 4 个特性等级，把 bracket 和 delimiter 踢出去
      (setq-local treesit-font-lock-feature-list
                  (mapcar (lambda (level)
                            (remq 'bracket (remq 'delimiter level)))
                          treesit-font-lock-feature-list))
      ;; 2. 强制 Tree-sitter 重新计算当前 buffer 的高亮规则
      (treesit-font-lock-recompute-features)))

  ;; 将这个规则挂载到你常用的 ts-mode 上
  (add-hook 'js-ts-mode-hook #'my/enable-rainbow-delimiters-for-ts)

  ;; 建议：顺手把你可能用到的其他前端 ts 模式也加上
  (add-hook 'typescript-ts-mode-hook #'my/enable-rainbow-delimiters-for-ts)
  (add-hook 'tsx-ts-mode-hook #'my/enable-rainbow-delimiters-for-ts))
;; 使用下面的代码列出已经安装的TS语法
;; (message "真正已安装的所有 TS 语法库: %s"
;;          (delete-dups
;;           (cl-mapcan (lambda
;;                        (dir) (when
;;                                  (and dir (file-exists-p dir))
;;                                (mapcar
;;                                 (lambda (file) (replace-regexp-in-string "^libtree-sitter-\\|\\..*$" "" file))
;;                                 (directory-files dir nil "^libtree-sitter-")
;;                                 )
;;                                )
;;                        ) treesit-extra-load-path)))

;; gptel OPTIONAL configuration
(use-package! gptel
  :defer t
  :config
  (setq gptel-model   'deepseek-reasoner
        gptel-backend (gptel-make-deepseek "DeepSeek"
                        :stream t
                        :key (getenv "DEEPSEEK_API_KEY"))))

;; configure svg-tag-mode with custom tags and styles
(use-package! svg-lib) ;; 这里可以直接去掉 :defer t
(use-package! svg-tag-mode
  :hook ((prog-mode . svg-tag-mode)
         (org-mode . svg-tag-mode))
  :config
  ;; 【关键修复】：在定义这些标签前，强制加载 svg-lib，确保 svg-lib-tag 函数可用
  (require 'svg-lib)

  (defconst date-re "[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}")
  (defconst time-re "[0-9]\\{2\\}:[0-9]\\{2\\}")
  (defconst day-re "[a-zA-Z]\\{3\\}")
  (defconst user-re "[A-Za-z0-9_]+")

  (setq svg-tag-tags
        `(
          ;; 核心 TODO 标签
          ("TODO" . ((lambda (tag)
                       (svg-lib-tag tag nil :stroke 0 :margin 0 :background "#FFB86C" :foreground "#282A36"))))
          ("FIXME" . ((lambda (tag)
                        (svg-lib-tag tag nil :stroke 0 :margin 0 :background "#FF5555" :foreground "#F8F8F2"))))
          ("BUG" . ((lambda (tag)
                      (svg-lib-tag tag nil :stroke 0 :margin 0 :background "#FF5555" :foreground "#F8F8F2"))))
          ("DONE" . ((lambda (tag)
                       (svg-lib-tag tag nil :stroke 0 :margin 0 :background "#50FA7B" :foreground "#282A36"))))
          ("NOTE" . ((lambda (tag)
                       (svg-lib-tag tag nil :stroke 0 :margin 0 :background "#8BE9FD" :foreground "#282A36"))))

          ;; 动态捕获：匹配类似 TODO(Chen): 的格式
          ("\\(TODO\\)(\\([a-zA-Z0-9_]+\\)):" .
           ((lambda (tag)
              (svg-lib-tag "TODO" nil :stroke 0 :margin 0 :background "#FFB86C" :foreground "#282A36"))
            (lambda (tag)
              (svg-lib-tag tag nil :stroke 0 :margin 0 :background "#6272A4" :foreground "#F8F8F2"))))

          ;; 动态捕获：将日期格式转化为日历样式的标签
          (,(format "\\(<%s>\\)" date-re) .
           ((lambda (tag)
              (svg-lib-tag tag nil :stroke 0 :margin 0 :padding 1 :background "#BD93F9" :foreground "#F8F8F2"))))
          )
        )
  )

;; Maxima configuration
;; ======== Maxima 基础编辑模式 ========
;; ======== Maxima 基础编辑模式 ========
(use-package! maxima
  ;; ✅ 修复这里：严格的 (("正则1" . mode) ("正则2" . mode)) 格式
  :mode (("\\.mac\\'" . maxima-mode)
         ("\\.max\\'" . maxima-mode))
  :commands (maxima maxima-mode)
  :config
  ;; 允许在执行命令时自动弹出 Maxima 交互窗口
  (setq maxima-display-buffer t))

;; ======== iMaxima (图片公式渲染核心) ========
(use-package! imaxima
  :commands imaxima
  :config
  ;; 1. 图片清晰度与缩放 (专治高分屏)
  (setq imaxima-scale-factor 1.5)

  ;; 2. ✅ 完美修复：动态读取当前 Doom 主题的默认字体颜色和背景颜色
  ;; face-foreground 和 face-background 会返回类似 "#F8F8F2" 的标准 16 进制颜色
  (setq imaxima-fg-color (face-foreground 'default)
        imaxima-bg-color (face-background 'default))

  ;; 3. 指定底层渲染格式
  (setq imaxima-image-type 'png)

  ;; 4. 关闭 LaTeX 编译时的临时文件回显噪音
  (setq imaxima-print-tex-command nil))

;;; config.el ends here
