let () =
  Reactive.init "test_cache_nested.rheap" (1024 * 1024);
  let t = Reactive.input_files [| "a.txt" |] in

  let failed =
    try
      let _ = Reactive.map t (fun key _ ->
        let _ = Reactive.map t (fun _ _ -> [||]) in
        [| (key, [| 1 |]) |]
      ) in
      false
    with _ -> true
  in
  assert failed;
  print_endline "nested map rejected"
