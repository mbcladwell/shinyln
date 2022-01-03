;; (use-modules
;;   (guix packages)
;;   ((guix licenses) #:prefix license:)
;;   (guix download)
;;   (guix build-system gnu)
;;   (gnu packages)
;;   (gnu packages autotools)
;;   (gnu packages guile)
;;   (gnu packages guile-xyz)
;;   (gnu packages pkg-config)
;;   (gnu packages cran)
;;   (labsolns r-pool)
;;   (gnu packages statistics)
;;   (guix build-system r)
;;   (gnu packages texinfo))

(define-module (shinyln)
  #:use-module (gnu packages cran)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system r)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bioinformatics)
  #:use-module (gnu packages c)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages fribidi)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages geo)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages graph)
  #:use-module (gnu packages gtk)
   #:use-module  (gnu packages guile)
   #:use-module (gnu packages guile-xyz)
   #:use-module (gnu packages haskell-xyz)
   
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages java)
  #:use-module (gnu packages javascript)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages machine-learning)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages node)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)  ;libsndfile
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages tcl)
  #:use-module (gnu packages textutils)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages uglifyjs)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages video)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml) 
  #:use-module (gnu packages xorg)
  #:use-module (labsolns r-pool)
  #:use-module (gnu packages texinfo)) 


(define-public shinyln
(package
  (name "shinyln")
  (version "0.1")
;;  (source "/home/mbc/temp/shinyln/shinyln-0.1.tar.gz")
(source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "git://github.com/mbcladwell/shinyln.git")
                      (commit "6debcfd6662e62aed4b2943bb826e478824de800")))
                (sha256 (base32 "0qn85c11r6x8kxmwm5rinw1fjbv82vmanfp2gl2a7c4sb4mzjlmn"))
		;; 0qn85c11r6x8kxmwm5rinw1fjbv82vmanfp2gl2a7c4sb4mzjlmn
               ;; (file-name (git-file-name name version))
		))
  (build-system gnu-build-system)
  (arguments `(	#:phases (modify-phases %standard-phases
					(add-after 'unpack 'patch-prefix
						   (lambda* (#:key inputs outputs #:allow-other-keys)
						     (substitute* "./scripts/shinyln.sh"
								  (("abcdefgh")
								   (assoc-ref outputs "out" )) )
						     #t))
					(add-before 'install 'copy-app
						    (lambda* (#:key outputs #:allow-other-keys)
						      (let* ((out  (assoc-ref outputs "out")))
							     (install-file "./app.R" out)     			     	     
							     #t)))
					(add-before 'install 'copy-executable
						    (lambda* (#:key outputs #:allow-other-keys)
						      (let* ((out  (assoc-ref outputs "out"))
							     (bin-dir (string-append out "/bin"))	    							     
							     )            				       
							(install-file "./scripts/shinyln.sh" bin-dir)
							#t)))
					(add-after 'install 'wrap-shinyln
						   (lambda* (#:key inputs outputs #:allow-other-keys)
						     (let* ((out (assoc-ref outputs "out"))
							    (bin-dir (string-append out "/bin"))					   
							    (dummy (chmod (string-append out "/bin/shinyln.sh") #o555 ))) ;;read execute, no write
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
		       ("r-shiny" ,r-shiny)
		       ("r-rpostgresql" ,r-rpostgresql)
		        ("r-ggplot2" ,r-ggplot2)
		        ("r-dbi" ,r-dbi)
			("r-pool" ,r-pool)
			("r-dt" ,r-dt)
			("r" ,r)
			("postgresql" ,postgresql)
			;;("libpqxx" ,libpqxx)
			;;("uglify-js" ,r-uglify-js)
			;;("ghc-postgresql-libpq" ,ghc-postgresql-libpq)
		       ))
  (synopsis "")
  (description "")
  (home-page "www.labsolns.com")
  (license license:gpl3+)))

shinyln



