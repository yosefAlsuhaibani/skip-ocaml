let () =
  let fname = "incr_input1.txt" in

  Reactive.init "test_incr_basic.rheap" (1024 * 1024);

  let inputs = Reactive.input_files [| fname |] in

  let contents =
    Reactive.map inputs (fun key trackers ->
      let s = Reactive.read_file key (Array.get trackers 0) in
      [| (key, [| s |]) |]
    )
  in

  let lengths =
    Reactive.map contents (fun key values ->
      let len = String.length values.(0) in
      [| (key, [| len |]) |]
    )
  in

  Reactive.exit ();

  let content = Reactive.get_array contents fname in
  let len = Reactive.get_array lengths fname in

  Printf.printf "Content: %s\nLength: %d\n" content.(0) len.(0)
