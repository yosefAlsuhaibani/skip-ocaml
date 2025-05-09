let () =
  Reactive.init "test_cache_map.rheap" (1024 * 1024);
  let t = Reactive.input_files [| "any.txt" |] in

  let _ = Reactive.map t (fun key _ ->
    let x = 42 in
    [| (key, [| x, x + 1 |]) |]  (* tuple, safe *)
  ) in

  print_endline "pure map passed"
