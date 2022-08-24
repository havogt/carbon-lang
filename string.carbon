package string api;

fn s2i(var s: String) -> i32 {
    match (s) {
    case "A" => {
      return 0;
    }
    case "B" => {
      return 1;
    }
    case "C" => {
      return 2;
    }
    case "D" => {
      return 3;
    }
    case "E" => {
      return 4;
    }
    default => {
      return 5;
    }
  }
}

class MyString{
    var data: [i32; 20];
    var _ptr: i32;
    var _convert: [String; 5];

    // TODO maybe with generic tuple?
    fn set[addr me: Self*](var s0: String) {
        (*me).data[0] = s2i(s0);
        (*me)._ptr = 1;
    }
    fn set[addr me: Self*](var s0: String, var s1: String) {
        (*me).data[0] = s2i(s0);
        (*me).data[1] = s2i(s1);
        (*me)._ptr = 2;
    }

    fn append[addr me: Self*](var s: String) {
        (*me).data[(*me)._ptr] = s2i(s);
        (*me)._ptr = (*me)._ptr + 1;
    }

    fn empty() -> MyString {
        return {.data = (1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), ._ptr = 4, ._convert = ("A", "B", "C", "D", "E")};
    }


    fn print[me:Self]() {
          var x: auto = 0;
  while (x < me._ptr) {
        Print(me._convert[me.data[x]]);
    x = x + 1;

  }
  Print("\n");
    }
}


fn Main() ->i32{
    var foo: auto = MyString.empty();
    // var foo: auto = MyString.empty();
    // var bar: i32 = foo.data[0];
    // bar = 1;
    // Print("{0}",f);
    foo.print();
    // (&foo).append("D");
    foo.append("D");
    foo.append("D");
    foo.print();
    foo.set("B");
    foo.print();
    return 0;
}