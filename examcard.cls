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
\usepackage{xifthen} %if-then-else
\usepackage{environ} %this one helps in creating new environments
\usepackage{dashbox} %this one makes dashed frames
\usepackage{datatool} %this one works with databases
\usepackage{longtable} %this one is required by datatool

\DTLnewdb{List} %initializing new database

%Page layout
\usepackage[top=1cm,bottom=1cm,left=1cm,right=1cm]{geometry} 

\pagestyle{empty} %no page numbering

%The following commands let the user use his own sizes for the card.
\newcommand{\setcardheight}[1] %this command sets height of the framebox
{\newcommand{\cardheight}{#1}} %this is a string constant

\newcommand{\setcardwidth}[1] %same here for width
{\newcommand{\cardwidth}{#1}} 

%Counters
\newcounter{questnum} %question number counter 
\newcounter{listcounter} %counter for generated list

%Question title with number
\newcommand{\questname}[2][]
{\stepcounter{questnum} %increase question number
\ifthenelse
%if option field is empty
{\isempty{#1}} 
%then type only question name
{\textbf{\large{\thequestnum. #2 }}\par
\DTLnewrow{List} %starting new row in the database
\DTLnewdbentry{List}{ }{\stepcounter{listcounter}\thelistcounter. #2} %sending all data to the database
}
%else type question name and class name (as written in option field)
{\textbf{\large{\thequestnum.}} \textit{#1} \textbf{#2}\par
\DTLnewrow{List} %starting new row in the database
\DTLnewdbentry{List}{ }{\stepcounter{listcounter}\thelistcounter. \textit{#1} #2} %sending all data to the database
}}  

%Question title without number
\newcommand{\questnamenonum}[2][]
{\ifthenelse
%if option field is empty
{\isempty{#1}} 
%then type only question name
{\textbf{\large{#2 }}\par
\DTLnewrow{List} %starting new row in the database
\DTLnewdbentry{List}{ }{#2} %sending all data to the database
}
%else type question name and class name (as written in option field)
{\textit{#1} \textbf{#2}\par
\DTLnewrow{List} %starting new row in the database
\DTLnewdbentry{List}{ }{\textit{#1} #2} %sending all data to the database
}}  

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

%Generate list
\newcommand{\listgen}{\DTLdisplaylongdb{List}}


