let () =
  Reactive.init "test_cache_get.rheap" (1024 * 1024);
  let t = Reactive.input_files [| "x.txt" |] in
  let m = Reactive.map t (fun key _ -> [| (key, [| key |]) |]) in

  let failed =
    try
      let _ = Reactive.get_array m "x.txt" in
      false
    with _ -> true
  in
  assert failed;
  print_endline "get_array before exit fails as expected"
