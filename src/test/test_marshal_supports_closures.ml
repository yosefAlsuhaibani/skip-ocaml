let () =
  Reactive.init "test_cache_marsh.rheap" (1024 * 1024);
  let t = Reactive.input_files [| "dummy.txt" |] in

  let m = Reactive.marshalled_map t (fun key _ ->
    let closure = (fun x -> x ^ "!") in
    [| (key, [| closure |]) |]
  ) in
  Reactive.exit ();
  let arr = Reactive.get_array m "dummy.txt" in
  let f = Reactive.unmarshal arr.(0) in
  assert (f "wow" = "wow!");
  print_endline "marshalled closure passed"
