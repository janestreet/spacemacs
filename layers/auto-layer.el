;;; auto-layer.el --- auto-mode-alist entries for layer installation  -*- lexical-binding: t; -*-
;;
;; Copyright (c) 2012-2025 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(configuration-layer/lazy-install 'ansible :extensions '("\\(\\.jinja2\\'\\|\\.j2\\'\\)" jinja2-mode))
(configuration-layer/lazy-install 'asciidoc :extensions '("\\(\\.adoc?$\\)" adoc-mode))
(configuration-layer/lazy-install 'autohotkey :extensions '("\\(\\.ahk\\'\\|\\.ahk$\\)" ahk-mode))
(configuration-layer/lazy-install 'csv :extensions '("\\(\\.[Cc][Ss][Vv]\\'\\)" csv-mode))
(configuration-layer/lazy-install 'fsharp :extensions '("\\(\\.fs[iylx]?$\\)" fsharp-mode))
(configuration-layer/lazy-install 'go :extensions '("\\(\\.go\\'\\)" go-mode))
(configuration-layer/lazy-install 'graphviz :extensions '("\\(\\.dot\\'\\|\\.gv\\'\\|\\.diag\\'\\|\\.blockdiag\\'\\|\\.nwdiag\\'\\|\\.rackdiag\\'\\)" graphviz-dot-mode))
(configuration-layer/lazy-install 'haskell :extensions '("\\(\\.[gh]s\\'\\|\\.hsc\\'\\)" haskell-mode))
(configuration-layer/lazy-install 'haskell :extensions '("\\(\\.cmm\\'\\)" cmm-mode))
(configuration-layer/lazy-install 'html :extensions '("\\(\\.css\\'\\)" css-mode))
(configuration-layer/lazy-install 'html :extensions '("\\(\\.haml\\'\\)" haml-mode))
(configuration-layer/lazy-install 'html :extensions '("\\(\\.jade\\'\\)" jade-mode))
(configuration-layer/lazy-install 'html :extensions '("\\(\\.less\\'\\)" less-css-mode))
(configuration-layer/lazy-install 'html :extensions '("\\(\\.phtml\\'\\|\\.tpl\\.php\\'\\|\\.twig\\'\\|\\.html\\'\\|\\.htm\\'\\|\\.[gj]sp\\'\\|\\.as[cp]x?\\'\\|\\.eex\\'\\|\\.leex\\'\\|\\.erb\\'\\|\\.mustache\\'\\|\\.handlebars\\'\\|\\.hbs\\'\\|\\.eco\\'\\|\\.ejs\\'\\|\\.djhtml\\'\\)" web-mode))
(configuration-layer/lazy-install 'html :extensions '("\\(\\.sass\\'\\)" sass-mode))
(configuration-layer/lazy-install 'html :extensions '("\\(\\.scss\\'\\)" scss-mode))
(configuration-layer/lazy-install 'html :extensions '("\\(\\.slim\\'\\)" slim-mode))
(configuration-layer/lazy-install 'javascript :extensions '("\\(\\.coffee\\'\\|\\.iced\\'\\|Cakefile\\'\\|\\.cson\\'\\)" coffee-mode))
(configuration-layer/lazy-install 'javascript :extensions '("\\(\\.js\\'\\)" js2-mode))
(configuration-layer/lazy-install 'javascript :extensions '("\\(\\.json$\\)" json-mode))
;; latex
(configuration-layer/lazy-install 'lua :extensions '("\\(\\.lua$\\|\\.lua\\'\\)" lua-mode))
(configuration-layer/lazy-install 'markdown :extensions '("\\(\\.markdown\\'\\|\\.md\\'\\|\\.m[k]d\\)" markdown-mode))
(configuration-layer/lazy-install 'nginx :extensions '("\\(nginx\\.conf\\'\\|/nginx/.+\\.conf\\'\\)" nginx-mode))
(configuration-layer/lazy-install 'octave :extensions '("\\(\\.m\\'\\)" octave-mode))
(configuration-layer/lazy-install 'perl5 :extensions '("\\.\\(p[lm]x?\\|P[LM]X?\\)\\'" cperl-mode))
(configuration-layer/lazy-install 'protobuf :extensions '("\\(\\.proto\\'\\)" protobuf-mode))
(configuration-layer/lazy-install 'python :extensions '("\\(\\.hy\\'\\)" hy-mode))
(configuration-layer/lazy-install 'python :extensions '("\\(\\.pip\\'\\|requirements\\(?:.\\|\n\\)*\\.txt\\'\\)" pip-requirements-mode))
(configuration-layer/lazy-install 'python :extensions '("\\(\\.py\\'\\)" python-mode) :interpreter '("python[0-9.]*" python-mode))
(configuration-layer/lazy-install 'python :extensions '("\\(\\.pyx\\'\\|\\.pxd\\'\\|\\.pxi\\'\\)" cython-mode))
(configuration-layer/lazy-install 'racket :extensions '("\\(\\.rkt[dl]?\\'\\)" racket-mode))
(configuration-layer/lazy-install 'react :extensions '("\\(\\.jsx$\\)" react-mode))
(configuration-layer/lazy-install 'ruby
  :extensions '("\\(\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'\\|Puppetfile\\)" ruby-mode))
(configuration-layer/lazy-install 'rust :extensions '("\\(\\.rs\\|Cargo.lock\\|\\.cargo/config\\)\\'" rust-mode))
(configuration-layer/lazy-install 'shell-scripts :extensions '("\\(\\.fish\\'\\|/fish_funced\\..*\\'\\)" fish-mode))
(configuration-layer/lazy-install 'sql :extensions '("\\(\\.sql\\'\\)" sql-mode))
(configuration-layer/lazy-install 'swift :extensions '("\\(\\.swift\\'\\)" swift-mode))
(configuration-layer/lazy-install 'systemd :extensions'("\\(\\.\\(nspawn\\|automount\\|busname\\|mount\\|service\\|slice\\|socket\\|swap\\|target\\|timer\\|link\\|netdev\\|network\\)\\'\\)" systemd-mode))
(configuration-layer/lazy-install 'toml :extensions '("\\.toml\\'" toml-mode))
(configuration-layer/lazy-install 'typescript :extensions '("\\(\\.ts$\\)" typescript-mode))
(configuration-layer/lazy-install 'vimscript :extensions '("\\(\\.vim\\'\\|[._]?g?vimrc\\'\\|\\.exrc\\'\\|_vimrc\\'\\|\\.vim[rc]?\\'\\)" vimrc-mode))
(configuration-layer/lazy-install 'vimscript :extensions '("\\(_vimperatorrc\\'\\|_pentadactylrc\\'\\|\\.penta\\'\\|vimperatorrc\\'\\|\\.vimp\\'\\|pentadactylrc\\'\\)" dactyl-mode))
(configuration-layer/lazy-install 'windows-scripts :extensions '("\\(\\.bat$\\)" dos-mode))
(configuration-layer/lazy-install 'windows-scripts :extensions '("\\(\\.ps[dm]?1\\'\\|\\.ps1$\\)" powershell-mode))
(configuration-layer/lazy-install 'yaml :extensions '("\\(\\.e?ya?ml$\\|\\.\\(yml\\|yaml\\)\\'\\|Procfile\\'\\)" yaml-mode))
