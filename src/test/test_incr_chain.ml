let () =
  let fname = "incr_input3.txt" in
  Reactive.init "test_incr_chain.rheap" (1024 * 1024);

  let inputs = Reactive.input_files [| fname |] in

  let contents =
    Reactive.map inputs (fun key trackers ->
      let s = Reactive.read_file key (Array.get trackers 0) in
      [| (key, [| s |]) |]
    )
  in

  let upper =
    Reactive.map contents (fun key arr ->
      let s = String.uppercase_ascii arr.(0) in
      [| (key, [| s |]) |]
    )
  in

  let reversed =
    Reactive.map upper (fun key arr ->
        let s =
          let orig = arr.(0) in
          let len = String.length orig in
          String.init len (fun i -> orig.[len - i - 1])
        in
      [| (key, [| s |]) |]
    )
  in

  Reactive.exit ();
  let out = Reactive.get_array reversed fname in
  Printf.printf "Final: %s\n" out.(0)
