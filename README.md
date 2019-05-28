# numba scaling tests

You need to pip install the module before using it.

# example analysis

See the folder `tests/laptop` for an example script (`job.sh`).

To reproduce, run the file `job.sh`. Then examine output profile trace. At the
top it should look something like this

```bash
$ head -n 20 data1.txt
0000: 6.938997
         1131113 function calls (1070989 primitive calls) in 8.726 seconds

   Ordered by: cumulative time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
    476/1    0.027    0.000    8.727    8.727 {built-in method builtins.exec}
        1    0.000    0.000    8.727    8.727 numba-test-script:2(<module>)
        1    5.355    5.355    5.355    5.355 numba_module.py:41(mult_a_lot)
   494/32    0.004    0.000    2.003    0.063 <frozen importlib._bootstrap>:966(_find_and_load)
   494/32    0.003    0.000    2.002    0.063 <frozen importlib._bootstrap>:936(_find_and_load_unlocked)
   475/33    0.003    0.000    1.994    0.060 <frozen importlib._bootstrap>:651(_load_unlocked)
   714/34    0.001    0.000    1.992    0.059 <frozen importlib._bootstrap>:211(_call_with_frames_removed)
   420/32    0.002    0.000    1.789    0.056 <frozen importlib._bootstrap_external>:672(exec_module)
      6/2    0.000    0.000    1.515    0.758 compiler_lock.py:29(_acquire_compile_lock)
6332/4152    0.009    0.000    1.423    0.000 <frozen importlib._bootstrap>:997(_handle_fromlist)
   468/56    0.001    0.000    1.422    0.025 {built-in method builtins.__import__}
        1    0.000    0.000    1.243    1.243 dispatcher.py:299(_compile_for_args)
        1    0.000    0.000    1.243    1.243 dispatcher.py:635(compile)
        1    0.000    0.000    1.242    1.242 dispatcher.py:71(compile)
```

Now look at `data2.txt`

```bash
$ head data2.txt
0000: 6.240304
         1131226 function calls (1071103 primitive calls) in 6.956 seconds

   Ordered by: cumulative time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
    476/1    0.029    0.000    6.956    6.956 {built-in method builtins.exec}
        1    0.000    0.000    6.956    6.956 numba-test-script:2(<module>)
        1    4.727    4.727    4.727    4.727 numba_module.py:41(mult_a_lot)
      6/2    0.000    0.000    1.213    0.607 compiler_lock.py:29(_acquire_compile_lock)
        1    0.000    0.000    1.155    1.155 dispatcher.py:299(_compile_for_args)
        1    0.000    0.000    1.154    1.154 dispatcher.py:635(compile)
        1    0.000    0.000    1.154    1.154 dispatcher.py:71(compile)
        1    0.000    0.000    1.154    1.154 compiler.py:915(compile_extra)
        1    0.000    0.000    0.974    0.974 compiler.py:357(compile_extra)
        1    0.000    0.000    0.973    0.973 compiler.py:867(_compile_bytecode)
        1    0.000    0.000    0.973    0.973 compiler.py:852(_compile_core)
        1    0.000    0.000    0.973    0.973 compiler.py:235(run)
   494/32    0.004    0.000    0.891    0.028 <frozen importlib._bootstrap>:966(_find_and_load)
   494/32    0.003    0.000    0.890    0.028 <frozen importlib._bootstrap>:936(_find_and_load_unlocked)
```

Note that in both cases (1 rank versus 2 ranks), a single task spends about
the same amount of time compiling code (and thus waiting for the numba
compile lock).
