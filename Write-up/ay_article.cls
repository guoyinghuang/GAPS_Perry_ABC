\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ay_article}[04/17/07 article class with additional packages and definitions]
%%
%%	this document is a wrapper for the article class that loads packages and defines commands
%%
%% this class operates on two new arguments:
%%		`endfloat'
%%			puts floats at the end
%%			(loads the endfloat package, but does so at \begin{document} to avoid conflicts)
%%		`doublespace'
%%			makes the document double-spaced
%%			(loads setspace with option 'doublespacing')
%% all other arguments to this class are passed to the article class
%%
%%
% CLASS ARGUMENTS
%	process `endfloat' option, but del
%\DeclareOption{endfloat}{\AtBeginDocument{\RequirePackage[nomarkers,nolists,noheads]{endfloat}}}
%	process `doublespace' option
\DeclareOption{doublespace}{\AtEndOfClass{\RequirePackage[doublespacing]{setspace}}}
%	pass any remaining options to class article
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
%
%
%
% PACKAGES
\RequirePackage{graphicx,geometry}%				general document layout
\RequirePackage{amsmath,amsfonts,amssymb}%		math fonts
\RequirePackage{lscape,rotating}%					change orientation of objects
\RequirePackage{booktabs,multicol,multirow,colortbl}%		table formatting
%\RequirePackage{subfig,caption}%					float formatting
\RequirePackage[sort]{natbib}%					natbib for bibliography
\RequirePackage{paralist}%						in-paragraph lists
%
%
%
% MATH COMMANDS
\newcommand{\st}{\ensuremath{~\vert~}}
\newcommand{\N}{\ensuremath{\mathbb{N}}}
\newcommand{\R}{\ensuremath{\mathbb{R}}}
\newcommand{\eqd}{\ensuremath{\buildrel d\over =}}
\newcommand{\onehalf}{\ensuremath{1/2}}
\newcommand{\setA}{\ensuremath{\mathcal{A}}}
\newcommand{\setB}{\ensuremath{\mathcal{B}}}
\newcommand{\setH}{\ensuremath{\mathcal{H}}}
\newcommand{\setP}{\ensuremath{\mathcal{P}}}
\newcommand{\setS}{\ensuremath{\mathcal{S}}}
\newcommand{\setT}{\ensuremath{\mathcal{T}}}
\newcommand{\setX}{\ensuremath{\mathcal{X}}}
%
% BIBLIOGRAPHY COMMANDS
\renewcommand{\cite}{\citet}
\newcommand{\citepstar}{\citep*}
\newcommand{\citealpstar}{\citealp*}
%
% keep this at the end to ensure a linebreak
