\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesPackage{TesiDiaUniroma3}[2008/02/13 v1.0 Tesi - DIA-Uniroma3]

\LoadClass[a4paper,11pt,oneside,italian]{memoir}

% Si utilizza la sillabazione italiana
\RequirePackage[italian]{babel}
% Load graphicx
\RequirePackage{graphicx}
% Line spacing
\RequirePackage{setspace}

% pacchetti per i font
\usepackage[T1]{fontenc}
% interlinea
\linespread{1.4}
% margini (la dimensione del blocco di testo viene regolata di conseguenza)
\setlrmarginsandblock{3.5cm}{3cm}{*}
% profondità dell'indice (settato per stampare fino alle sottosezioni)
\setcounter{tocdepth}{2}
% numera parti, capitoli, sezioni, sottosezioni e sotto-sottosezioni
\maxsecnumdepth{subsubsection}
\setsecnumdepth{subsubsection}

\let\footruleskip\relax % for compatibility of memoir and fancyhdr
\let\rm\rmfamily        % for compatibility of memoir and blindtext (demo only)
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\addtolength{\headheight}{14pt}
\fancyhead[R]{\textbf{\thepage}}
\fancyhead[L]{\textbf{\leftmark}}

% Autore 
\newcommand{\@autoreprimo}{Autore 1}
\newcommand{\@autoresecondo}{Autore 2}
\newcommand{\@autoreterzo}{Autore 3}
\newcommand{\autoreprimo}[1]{\renewcommand{\@autoreprimo}{#1}}
\newcommand{\autoresecondo}[1]{\renewcommand{\@autoresecondo}{#1}}
\newcommand{\autoreterzo}[1]{\renewcommand{\@autoreterzo}{#1}}

% Titolo
\newcommand{\@titolo}{Titolo della tesi}
\newcommand{\titolo}[1]{\renewcommand{\@titolo}{#1}}

% Matricola 
\newcommand{\@matricolaprima}{000000}
\newcommand{\matricolaprima}[1]{\renewcommand{\@matricolaprima}{#1}}

% Github
\newcommand{\@github}{link github}
\newcommand{\github}[1]{\renewcommand{\@github}{\href{#1}{#1}}}

\newcommand{\@matricolaseconda}{000000}
\newcommand{\matricolaseconda}[1]{\renewcommand{\@matricolaseconda}{#1}}

\newcommand{\@matricolaterza}{000000}
\newcommand{\matricolaterza}[1]{\renewcommand{\@matricolaterza}{#1}}

% Generazione del FRONTESPIZIO
\newcommand{\generaFrontespizio}{
   \thispagestyle{empty}
   \begin{center}
      \vspace{10mm}
      {\includegraphics[width=0.4 \linewidth]{img/uniroma3-logo}} \\
      \vspace{10mm}
      {\Large UNIVERSIT\`A DEGLI STUDI ROMA TRE} \\
      \vspace{5mm}
      {\LARGE Dipartimento di Ingegneria} \\
      {\Large Corso di Laurea in Ingegneria Informatica} \\
      \vspace{15mm}
      {\LARGE Progetto Cybersecurity} \\
      \vspace{15mm}
      {\HUGE \@titolo} \\
      \vspace{15mm}
      \begin{tabular}{c c c}
       \textbf{\@autoreprimo} & \textbf{\@autoresecondo} & \textbf{\@autoreterzo} \\
       Matricola \@matricolaprima & Matricola \@matricolaseconda & Matricola \@matricolaterza \\
      \end{tabular} \\
      \vspace{7mm}
      {\begin{figure}[h]
        \centering
            \begin{tabular}{m{1cm}c}
            \includegraphics[scale=0.01]{tesina/img/GitHub-logo.png} & \@github\\
            \end{tabular}
       \end{figure}
      }
      \vfill
      {\large \today} \\
   \end{center}
   \newpage 
}

% Comandi riguardanti l'inserimento di capitoli
\newcommand{\introduzione}[1]{\newpage \chapter{Abstract} \input{#1}}
\newcommand{\capitolo}[2]{\newpage \chapter{#1}\label{cap:#2}\input{#2}}
\newcommand{\sezione}[2]{\section{#1}\label{sez:#2}\input{#2}}

% Comandi riguardanti la generazione di indici
\newcommand{\generaIndice}{
	%\fancyhead[L]{\textbf{\rightmark}}
	\newpage
	\tableofcontents
	\clearpage
	%\fancyhead[L]{\textbf{\leftmark}}
}
\newcommand{\generaIndiceTabelle}{\listoftables}
\newcommand{\generaIndiceFigure}{\listoffigures}

% Bibliografia in ordine alfabetico
\let \OldBib \bibliography
\renewcommand{\bibliography}[1]{\newpage \markboth{Bibliografia}{Bibliografia} \OldBib{#1}}
\bibliographystyle{alpha}
