let () =
  Reactive.init "test_cache_closure.rheap" (1024 * 1024);
  let t = Reactive.input_files [| "a.txt" |] in

  let failed =
    try
      let _ = Reactive.map t (fun key _ ->
        let closure = (fun x -> x + 1) in
        [| (key, [| closure |]) |]
      ) in
      false
    with _ -> true
  in
  assert failed;
  print_endline "closure rejected as expected"
