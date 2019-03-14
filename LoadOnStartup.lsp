;;
;;	LoadOnStartup
;;	Author: Andrew Loebs
;;	Desc: Called by our CUI_Template.mnl every time we open a new doc. Loads all files
;;			in the "Lisp" folder, as well as the assemblies we specify
;;
(defun LoadOnStartup ()
	;; Store current error handler, temporarily define our own
	(setq tempErr *error*)
	(setq *error* Trap1)

	;; Store current cmdecho, set to 0
	(setq oldCmdecho (getvar "cmdecho"))
	(setvar "cmdecho" 0)

	;; Load assemblies one by one. If an assembly is loaded into your AutoCAD instance, you cannot
	;; overwrite the assembly file with one from a new build. For this reason, updates to assemblies
	;; are best handled by being put into seperate folders per version. This file will have to be
	;; updated to point to the newest file location.

	;; Load the command method template
	(setq commandMethodTemplate (findfile "Assemblies/CommandMethodTemplate/v1.0/CommandMethodTemplate.dll"))
	(if (= commandMethodTemplate nil)
		(Trap1)
	)
	(command "_netload" commandMethodTemplate)

	;; Load the lisp function template
	(setq lispFunctionTemplate (findfile "Assemblies/LispFunctionTemplate/v1.0/LispFunctionTemplate.dll"))
	(if (= lispFunctionTemplate nil)
		(Trap1)
	)
	(command "_netload" lispFunctionTemplate)
	
	;; Load all lisp routines. These can be loaded, overwritten, etc., so we don't
	;; worry about specifying seperate version folders for them.
	(LoadAllLisp)

	;; Report success
	(write-line "\nLoad on startup successfully completed!")
	;; Restore error handler, cmdecho
	(setq *error* tempErr)
	(setvar "cmdecho" oldCmdecho)
)

;; Loads all lisp routines
(defun LoadAllLisp ()
	(vl-load-com)

	;; Get list of our lisp files within the "Lisp" folder
	(setq lispDirPath (findfile "Lisp"))
	(setq lispFileNames (vl-directory-files lispDirPath "*.lsp" 1))

	;; Ensure we've found them
	(if (= lispFileNames nil)
		(Trap1)
	)

	;; Load LISP routines
	(foreach lispFileName lispFileNames
		(load (strcat lispDirPath "\\" lispFileName))
 	)
)

;; Error handler
(defun Trap1 (errmsg)
	;; Restore error handler, cmdecho
	(setq *error* tempErr)
	(setvar "cmdecho" oldCmdecho)

	;; Print help message and quit
	(write-line "\nLoad on startup failed. Ensure that the AutoCAD customization template directory is included in your support file search paths under the \"Options\" menu.")
	(exit)
   	(princ)
)