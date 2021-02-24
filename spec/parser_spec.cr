require "./spec_helper"

describe Lucash::Parser do
  it "should raise a parse error with bad input" do
    expect_raises(Lucash::ParseError) { parse("(((") }
    expect_raises(Lucash::ParseError) { parse("end") }
    expect_raises(Lucash::ParseError) { parse("if") }
    expect_raises(Lucash::ParseError) { parse("if foo else") }
    expect_raises(Lucash::ParseError) { parse("}") }
  end

  it "should return an AST for variables" do
    parse("foo").should eq([:program, [
      [:value, "foo"],
    ]])

    parse("()").should eq([:program, [
      [:empty_parens],
    ]])

    parse("echo -la").should eq([:program, [
      [:value, "echo", "-la"],
    ]])

    parse("\"echo -l'a(}\"").should eq([:program, [
      [:embedded_string, "echo -l'a(}"],
    ]])

    parse("'echo -l\"\"a(}'").should eq([:program, [
      [:string, "echo -l\"\"a(}"],
    ]])

    parse("echo -la &").should eq([:program, [
      [:background, [:value, "echo", "-la"]],
    ]])
  end

  it "should return an AST for math" do
    parse("1 + 3.0\n      \n \n").should eq([:program, [
      [:+,
       [:number, 1], [:number, 3.0],
      ],
    ]])

    parse("1 + 3.0\n      \n 1\n").should eq([:program, [
      [:+,
       [:number, 1], [:number, 3.0],
      ],
      [:number, 1],
    ]])

    parse("foo + bar").should eq([:program, [
      [:+,
       [:value, "foo"],
       [:value, "bar"],
      ],
    ]])

    parse("5 + x * 10 - y").should eq([:program, [
      [:-,
       [:+,
        [:number, 5],
        [:*,
         [:value, "x"],
         [:number, 10],
        ],
       ],
       [:value, "y"],
      ],
    ]])

    parse("(5 + x) * (10 - y)").should eq([:program, [
      [:*,
       [:program, [
         [:+,
          [:number, 5],
          [:value, "x"],
         ],
       ]],
       [:program, [
         [:-,
          [:number, 10],
          [:value, "y"],
         ],
       ]],
      ],
    ]])
  end

  it "should return an AST for conditionals" do
    parse("if true; echo foobar; end").should eq([:program, [
      [:if,
       [:value, "true"],
       [:program, [
         [:value, "echo", "foobar"],
       ]],
      ],
    ]])

    parse("if true\n echo foobar\n end").should eq([:program, [
      [:if,
       [:value, "true"],
       [:program, [
         [:value, "echo", "foobar"],
       ]],
      ],
    ]])

    parse("if (cd; true); echo foobar; end").should eq([:program, [
      [:if,
       [:program, [
         [:value, "cd"],
         [:value, "true"],
       ]],
       [:program, [
         [:value, "echo", "foobar"],
       ]],
      ],
    ]])

    parse("if true; echo foobar\nelse; 123; end").should eq([:program, [
      [:if,
       [:value, "true"],
       [:program, [
         [:value, "echo", "foobar"],
       ]],
       [:program, [
         [:number, 123],
       ]],
      ],
    ]])

    parse("if true; echo foobar; else 123; end").should eq([:program, [
      [:if,
       [:value, "true"],
       [:program, [
         [:value, "echo", "foobar"],
       ]],
       [:program, [
         [:number, 123],
       ]],
      ],
    ]])
  end

  it "should return an AST for assignment" do
    parse("foo = 3").should eq([:program, [
      [:assignment,
       [:value, "foo"],
       [:number, 3],
      ],
    ]])

    parse("foo = 3 / 4").should eq([:program, [
      [:assignment,
       [:value, "foo"],
       [:slash,
        [:number, 3],
        [:number, 4],
       ],
      ],
    ]])

    parse("def foo(); 3; end").should eq([:program, [
      [:assignment,
       [:value, "foo"],
       [:lambda,
        nil,
        [:program, [
          [:number, 3],
        ]],
       ],
      ],
    ]])

    parse("def foo; 3; end").should eq([:program, [
      [:assignment,
       [:value, "foo"],
       [:lambda,
        nil,
        [:program, [
          [:number, 3],
        ]],
       ],
      ],
    ]])

    parse("foo = -> (x) { 3 + x }").should eq([:program, [
      [:assignment,
       [:value, "foo"],
       [:lambda,
        [:splat, [
          [:program, [
            [:value, "x"],
          ]],
        ]],
        [:program, [
          [:+,
           [:number, 3],
           [:value, "x"],
          ],
        ]],
       ],
      ],
    ]])

    parse("def foo(x) 3 + x end").should eq([:program, [
      [:assignment,
       [:value, "foo"],
       [:lambda,
        [:splat, [
          [:program, [
            [:value, "x"],
          ]],
        ]],
        [:program, [
          [:+,
           [:number, 3],
           [:value, "x"],
          ],
        ]],
       ],
      ],
    ]])

    # TBD THIS TEST IS TROUBLESOME FOR SOME REASON
    #    parse("def factorial(n)
    #      -> (n, acc) {
    #        if n == 0
    #          acc
    #        else
    #          retry(n - 1, acc * n)
    #        end
    #      } (n, 1)
    #    end").should eq([:program, [
    #      [:assignment,
    #       [:value, "factorial"],
    #       [:lambda,
    #        [:splat, [
    #          [:program, [
    #            [:value, "n"],
    #          ]],
    #        ]],
    #        [:program, [
    #          [:args,
    #           [:lambda,
    #            [:splat, [
    #              [:program, [
    #                [:value, "n"],
    #              ]],
    #              [:program, [
    #                [:value, "acc"],
    #              ]],
    #            ]],
    #            [:program, [
    #              [:if,
    #               [:==,
    #                [:value, "n"],
    #                [:number, 0],
    #               ],
    #               [:program, [
    #                 [:value, "acc"],
    #               ]],
    #               [:program, [
    #                 [:args,
    #                  [:value, "retry"],
    #                  [:splat, [
    #                    [:program, [
    #                      [:-,
    #                       [:value, "n"],
    #                       [:number, 1],
    #                      ],
    #                    ]],
    #                    [:program, [
    #                      [:*,
    #                       [:value, "acc"],
    #                       [:value, "n"],
    #                      ],
    #                    ]],
    #                  ]],
    #                 ],
    #               ]],
    #              ],
    #            ]],
    #           ],
    #           [:splat, [
    #             [:program, [
    #               [:value, "n"],
    #             ]],
    #             [:program, [
    #               [:number, 1],
    #             ]],
    #           ]],
    #          ],
    #        ]],
    #       ]],
    #    ]])
  end

  it "should return an AST for or's and and's" do
    parse("foo || bar").should eq([:program, [
      [:or,
       [:value, "foo"],
       [:value, "bar"],
      ],
    ]])

    parse("foo && bar").should eq([:program, [
      [:and,
       [:value, "foo"],
       [:value, "bar"],
      ],
    ]])
  end

  it "should return an AST for pipes" do
    parse("foo | bar").should eq([:program, [
      [:pipe,
       [:value, "foo"],
       [:value, "bar"],
      ],
    ]])
  end

  it "should return an AST for method calls" do
    parse("foo.bar").should eq([:program, [
      [:method,
       [:value, "foo"],
       [:value, "bar"],
      ],
    ]])

    parse("foo.bar { baz }").should eq([:program, [
      [:method,
       [:value, "foo"],
       [:yield,
        [:value, "bar"],
        [:program, [
          [:value, "baz"],
        ]],
       ],
      ],
    ]])

    parse("foo.bar()").should eq([:program, [
      [:method,
       [:value, "foo"],
       [:value, "bar"],
      ],
    ]])

    parse("foo.bar(baz)").should eq([:program, [
      [:method,
       [:value, "foo"],
       [:args,
        [:value, "bar"],
        [:splat, [
          [:program, [
            [:value, "baz"],
          ]],
        ]],
       ],
      ],
    ]])

    parse("foo.bar(baz, aba)").should eq([:program, [
      [:method,
       [:value, "foo"],
       [:args,
        [:value, "bar"],
        [:splat,
         [
           [:program, [
             [:value, "baz"],
           ]],
           [:program, [
             [:value, "aba"],
           ]],
         ],
        ],
       ],
      ],
    ]])

    parse("foo.bar(baz, aba) { bab }").should eq([:program, [
      [:method,
       [:value, "foo"],
       [:yield,
        [:args,
         [:value, "bar"],
         [:splat, [
           [:program, [
             [:value, "baz"],
           ]],
           [:program, [
             [:value, "aba"],
           ]],
         ]],
        ],
        [:program, [
          [:value, "bab"],
        ]],
       ],
      ],
    ]])

    parse("foo.bar(baz, aba) + 1").should eq([:program, [
      [:+,
       [:method,
        [:value, "foo"],
        [:args,
         [:value, "bar"],
         [:splat,
          [
            [:program, [
              [:value, "baz"],
            ]],
            [:program, [
              [:value, "aba"],
            ]],
          ],
         ],
        ],
       ],
       [:number, 1],
      ],
    ]])

    parse("foo.bar + 1").should eq([:program, [
      [:+,
       [:method,
        [:value, "foo"],
        [:value, "bar"],
       ],
       [:number, 1],
      ],
    ]])

    parse("foo.bar && 1").should eq([:program, [
      [:and,
       [:method,
        [:value, "foo"],
        [:value, "bar"],
       ],
       [:number, 1],
      ],
    ]])

    parse("foo.(bar + 1)").should eq([:program, [
      [:method,
       [:value, "foo"],
       [:program, [
         [:+,
          [:value, "bar"],
          [:number, 1],
         ],
       ]],
      ],
    ]])

    parse("foo(3)").should eq([:program, [
      [:args,
       [:value, "foo"],
       [:splat, [
         [:program, [
           [:number, 3],
         ]],
       ]]],
    ]])

    parse("foo.(bar + 1)(3)").should eq([:program, [
      [:method,
       [:value, "foo"],
       [:args,
        [:program, [
          [:+,
           [:value, "bar"],
           [:number, 1],
          ],
        ]],
        [:splat, [
          [:program, [
            [:number, 3],
          ]],
        ]],
       ],
      ],
    ]])

    parse("foo.(bar + 1)(3) + 1").should eq([:program, [
      [:+,
       [:method,
        [:value, "foo"],
        [:args,
         [:program, [
           [:+,
            [:value, "bar"],
            [:number, 1],
           ],
         ]],
         [:splat, [
           [:program, [
             [:number, 3],
           ]],
         ]],
        ],
       ],
       [:number, 1],
      ],
    ]])
  end
end
