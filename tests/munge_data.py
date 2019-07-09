import os
import glob
import sys
import subprocess

import numpy as np


def _extract_data(tail):
    fnames = glob.glob('data*%s.txt' % tail)
    print('number of files:', len(fnames), flush=True)

    # extract number of ranks
    ranks = [
        int(os.path.basename(fname).split('_')[0].replace('data', ''))
        for fname in fnames]

    # now extract max times
    run_times = []
    std_run_times = []
    compile_times = []
    std_compile_times = []
    for fname, n_ranks in zip(fnames, ranks):
        # munge the run time
        output = subprocess.check_output(
                'grep -E "[0-9]{4}:" %s' % fname,
                shell=True).decode('utf-8')
        data = []
        for line in output.split('\n'):
            line = line.strip()
            if line == '':
                continue
            data.append(float(line.split(':')[1].strip()))
        run_times.append(np.max(data))
        std_run_times.append(np.std(data))

        # munge the compile time
        try:
            output = subprocess.check_output(
                    'grep "_acquire_compile_lock" %s' % fname,
                    shell=True).decode('utf-8')
            data = []
            for line in output.split('\n'):
                line = line.strip()
                if line == '':
                    continue
                data.append(float(line.split()[3]))
            compile_times.append(np.max(data))
            std_compile_times.append(np.std(data))
        except Exception:
            compile_times.append(np.nan)
            std_compile_times.append(np.nan)

    print('rank     run run_sd    cmp cmp_sd')
    inds = np.argsort(ranks)
    for ind in inds:
        loss = run_times[ind] / run_times[inds[0]]
        print('% 5d % 6.2f % 6.2f % 6.2f % 6.2f % 6.2f' % (
            ranks[ind], run_times[ind], std_run_times[ind],
            compile_times[ind], std_compile_times[ind],
            loss))

    return (
        np.array(ranks)[inds],
        np.array(run_times)[inds],
        np.array(std_run_times)[inds],
        np.array(compile_times)[inds],
        np.array(std_compile_times)[inds])


tail = sys.argv[1]
ranks, r, _, c, _ = _extract_data(tail)
ranks_nn, r_nn, _, c_nn, _ = _extract_data(tail+'_nn')


# make a plot
if False:
    import matplotlib.pyplot as plt
    plt.figure()
    plt.plot(ranks, r, label='run - numba')
    plt.plot(ranks, c, label='compile - numba')
    plt.plot(ranks_nn, r_nn, label='run - no numba')
    plt.legend()
    plt.xlabel('# of ranks')
    plt.ylabel('time [seconds]')
    plt.show()
