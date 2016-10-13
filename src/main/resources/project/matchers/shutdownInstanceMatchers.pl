
push (@::gMatchers,
  {
   id =>        "serverTurnedOff",
   pattern =>          q{\"outcome\" => \"success\"(.+)},
   action =>           q{
    
                 my $description = "Server was turned off successfully.";
              setProperty("summary", $description . "\n");
    
   },
  },
);
