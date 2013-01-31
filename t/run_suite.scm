;(define target-mudule "t.hello-suite")

(use gauche.unit)
(use gauche.sequence)

(use t.hello-suite)

(let1 mod (find-module 't.hello-suite)
#;      (assert (module? mod) (is #t))
#;      (assert (module-name mod) (is 't.hello-suite))
      (let1 exports (module-exports mod)
#;	    (assert (length exports) (is 1))
#;	    (assert (~ exports 0) (is 'hello-test))
	    (eval `(,(~ exports 0)) (interaction-environment))
	    )
      )

