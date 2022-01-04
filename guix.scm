
(define-module (shinyln)
  #:use-module (gnu packages cran)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system r)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages gcc)
   #:use-module  (gnu packages guile)
   #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages uglifyjs)
  #:use-module (labsolns r-pool)
  #:use-module (gnu packages texinfo)) 


(define-public shinyln
(package
  (name "shinyln")
  (version "0.1")
(source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "git://github.com/mbcladwell/shinyln.git")
                      (commit "3e2cccc205c154b1c1bd29f5403a4358f40d8ecc")))
                (sha256 (base32 "0496ygandfcdgpcpz0p3bclgqxm0wsnkgp0inb6py5dhhbax9svs"))
		))
  (build-system gnu-build-system)
  (arguments `(	#:phases (modify-phases %standard-phases
					(add-after 'unpack 'patch-prefix                                ;;1 add path into /gnu/store
						   (lambda* (#:key inputs outputs #:allow-other-keys)
						     (substitute* "./scripts/shinyln.sh"
								  (("abcdefgh")
								   (assoc-ref outputs "out" )) )
						     #t))
					(add-before 'install 'copy-app                                  ;;2 copy app.R into the top level directory 'out'
						    (lambda* (#:key outputs #:allow-other-keys)
						      (let* ((out  (assoc-ref outputs "out")))
							     (install-file "./app.R" out)     			     	     
							     #t)))
					(add-before 'install 'copy-executable                           ;;3 copy ./scripts/shinyln.sh to out/bin shinyln.sh
						    (lambda* (#:key outputs #:allow-other-keys)
						      (let* ((out  (assoc-ref outputs "out"))
							     (bin-dir (string-append out "/bin"))	    							     
							     )            				       
							(install-file "./scripts/shinyln.sh" bin-dir)
							#t)))
					(add-after 'install 'wrap-shinyln                               ;;4 put shinyln.sh on the PATH
						   (lambda* (#:key inputs outputs #:allow-other-keys)
						     (let* ((out (assoc-ref outputs "out"))
							    (bin-dir (string-append out "/bin")))					   
							   ;; (dummy (chmod (string-append out "/bin/shinyln.sh") #o555 ))) ;;read execute, no write
						       (wrap-program (string-append out "/bin/shinyln.sh")
								     `( "PATH" ":" prefix  (,bin-dir) ))
						       #t)))					
	      ) ))
  (native-inputs
    `(("autoconf" ,autoconf)
      ("automake" ,automake)
      ("pkg-config" ,pkg-config)
      ("texinfo" ,texinfo)))
  (inputs `(("guile" ,guile-3.0)		      		      		       
	    ))
  (propagated-inputs `(
		       ("r" ,r)
		       ("r-shiny" ,r-shiny)
		       ("postgresql" ,postgresql)
		       ("r-dbi" ,r-dbi)
		       ("r-pool" ,r-pool)
		       ("r-dt" ,r-dt)
		       ("r-ggplot2" ,r-ggplot2)
		       ("r-rpostgresql" ,r-rpostgresql)		       
		       ))
  (synopsis "")
  (description "")
  (home-page "www.labsolns.com")
  (license license:gpl3+)))

shinyln



