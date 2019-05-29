import os
import sys
import subprocess

import matplotlib.pyplot as plt
import numpy as np


fnames = sys.argv[1:]
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
    print(fname)

    # munge the run time
    output = subprocess.check_output(
            'grep -E "\\d{4}:" %s' % fname,
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

print('rank     run run_sd    cmp cmp_sd')
inds = np.argsort(ranks)
for ind in inds:
    loss = run_times[ind] / run_times[inds[0]]
    print('% 5d % 6.2f % 6.2f % 6.2f % 6.2f % 6.2f' % (
        ranks[ind], run_times[ind], std_run_times[ind],
        compile_times[ind], std_compile_times[ind],
        loss))

# make a plot
plt.figure()
plt.loglog(
    np.array(ranks)[inds], np.array(run_times)[inds], label='total run')
plt.loglog(
    np.array(ranks)[inds], np.array(compile_times)[inds], label='compile')
plt.legend()
plt.xlabel('# of ranks')
plt.ylabel('time [seconds]')
plt.show()
