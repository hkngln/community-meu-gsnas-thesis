// LaTeX şablonundaki \newtheorem ortamları: hepsi tek sayaç paylaşır ve
// alt bölüme göre numaralanır (Tanım 2.1.1, Teorem 2.1.2 …). Figure olarak
// kurulduğu için <etiket> + @etiket ile atıf yapılabilir. PDF'e basılan
// etiketler Türkçedir; fonksiyon adları İngilizcedir.

#let THEOREM-KIND = "meu-theorem"

// Alt bölümde: 2.1.3; ilk "==" başlığından önce: 2.3 (".0." çıkmasın).
#let _theorem-number(..n) = {
  let h = counter(heading).get()
  let parents = (h.at(0, default: 0), h.at(1, default: 0)).filter(x => x != 0)
  (parents + n.pos()).map(str).join(".")
}

// label: PDF'e basılacak ad, ör. [Tanım].
#let theorem-env(label) = (body, title: none) => figure(
  kind: THEOREM-KIND,
  supplement: label,
  numbering: _theorem-number,
  outlined: false,
  {
    if title != none [(#title) ]
    body
  },
)

#let theorem-style(doc) = {
  show figure.where(kind: THEOREM-KIND): set block(breakable: true)
  show figure.where(kind: THEOREM-KIND): it => align(left, block(width: 100%, {
    strong[#it.supplement #it.counter.display(it.numbering).]
    [ ]
    it.body
  }))
  doc
}

#let definition = theorem-env[Tanım]
#let theorem = theorem-env[Teorem]
#let example = theorem-env[Örnek]
#let proposition = theorem-env[Önerme]
#let remark = theorem-env[Uyarı]
#let note = theorem-env[Not]
#let corollary = theorem-env[Sonuç]
#let lemma = theorem-env[Lemma]

#let proof(body) = block(width: 100%)[_Kanıt._ #body #h(1fr) $square$]
