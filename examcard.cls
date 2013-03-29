%Examcard is a custom document class for LATEX. Thic class provides tools for creating examination cards.

%Copyright (C) 2013 Gleb Gorbatovsky <http://techmarine712@gmail.com>

%Exancard is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.

%Examcard is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
 %MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.

%You should have received a copy of the GNU General Public License
%along with this program.  If not, see <http://www.gnu.org/licenses/>.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{examcard}[2013/03/15 Custom class for examination cards]

%Based on class:
\LoadClass{article}

%Packages
\RequirePackage{xifthen} %if-then-else
\RequirePackage{environ} %this one helps in creating new environments
\RequirePackage{dashbox} %this one makes dashed frames
\RequirePackage{datatool} %this one works with databases
\RequirePackage{longtable} %this one is required by datatool
\RequirePackage{tikz} %this one is used in headers
\RequirePackage[utf8x]{inputenc} %this one is for languages

%Adaptive header translation
\providecommand*{\tran}{Card}

\AtBeginDocument{
\@ifpackagewith{babel}{russian}{%
\addto\captionsrussian{\renewcommand*\tran{Билет}}%
}{}
\@ifpackagewith{babel}{english}{%
\addto\captionsenglish{\renewcommand*\tran{Card}}%
}{}
}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax


\DTLnewdb{List} %initializing new database

\pagestyle{empty} %no page numbering

%The following commands let the user use his own sizes for the card.
\newcommand{\setcardheight}[1] %this command sets height of the framebox
{\newcommand{\cardheight}{#1}} %this is a string constant

\newcommand{\setcardwidth}[1] %same here for width
{\newcommand{\cardwidth}{#1}} 

%Card header
\newcommand{\cardhead}[2][lime] %default color is lime
{\begin{tikzpicture}
\path [fill=#1] (0,0) rectangle (\cardwidth,1); %this is a background (width is set to \cardwidth, height is set to 1cm}
\node [font=\sffamily, font =\Large, anchor=north west, yshift=0.8cm] at (0,0) {\tran~#2}; %text with number 
\end{tikzpicture}\par}

%Question command
\newcommand{\quest}[3][NoClass]
{#2. #3
\DTLnewrow{List} %starting new row in the database
\DTLnewdbentry{List}{num}{#2} %Number entry
\DTLnewdbentry{List}{quest}{#3} %Question entry
\DTLnewdbentry{List}{class}{#1} %Class entry
}

%Card environment
\NewEnviron{card}
{
%Width and height of the card must be specified in order to use this environment. If the user didn't set his own values, the standard ones will be used.
\ifthenelse
{\isundefined{\cardheight}} %if \cardheight command is undefined
{\setcardheight{70mm}} %then set height to 70mm
{} %else do nothing
\ifthenelse
{\isundefined{\cardwidth}} %if \cardwidth command is undefined
{\setcardwidth{90mm}}  %then set width to 90mm
{} %else do nothing
\noindent 
\dashbox
{\begin{minipage}[t][\cardheight][t]{\cardwidth}{\BODY}\end{minipage}}\vspace{1mm}} %card itself

%Generate full list
\newcommand{\listgen}{%
\DTLsort{num}{List} %sorting by number
\DTLforeach*{List} %iterating through the list
{\num=num,\quest=quest} %assigning keys
{\num. \quest\\} %typing
}

%Generate list of a given class
\newcommand{\classlist}[1]{%
\DTLsort{num}{List} %sorting by number
\DTLforeach*[\DTLiseq{\class}{#1}]{List} %filtering entries and iterating
{\num=num, \quest=quest, \class=class} %assigning keys
{\num. \quest\\} %typing
}

