let () =
  let fname = "test_input.txt" in
  let content = "hello" in
  let oc = open_out fname in
  output_string oc content;
  close_out oc;

  Reactive.init "test_cache_io.rheap" (1024 * 1024);
  let t = Reactive.input_files [| fname |] in
  let out =
    Reactive.map t (fun key trackers ->
      let s = Reactive.read_file key (Array.get trackers 0) in
      [| (key, [| s |]) |]
    )
  in
  Reactive.exit ();
  let data = Reactive.get_array out fname in
  assert (Array.length data = 1);
  assert (data.(0) = content);
  print_endline "input/output passed"
