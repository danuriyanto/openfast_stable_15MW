function copy_openfast_sh(total_task_number,runIndex)
C(1,1) = {['#!/bin/bash	']};
C(end+1,1) = {['#SBATCH --job-name=openfast_simulation	']};
C(end+1,1) = {['#SBATCH --time=12:00:00	']};
C(end+1,1) = {['#SBATCH --partition=short	']};
C(end+1,1) = {['#SBATCH --mem=2G	']};
C(end+1,1) = {['#SBATCH --cpus-per-task=1	']};
C(end+1,1) = {['#SBATCH --output=output_%A_%a.txt	']};
C(end+1,1) = {['#SBATCH --error=error_%A_%a.txt	']};
C(end+1,1) = {['#SBATCH --mail-type=BEGIN,END,FAIL 	']};
C(end+1,1) = {['#SBATCH --mail-user=riyanto.r@northeastern.edu	']};
C(end+1,1) = {['#SBATCH --array=1-' num2str(total_task_number)	]};
C(end+1,1) = {[' ']};

if runIndex == 1000
C(end+1,1) = {['openfast *_tasknum_$((SLURM_ARRAY_TASK_ID)).fst']};
writecell(C,['run_' num2str((runIndex/1000)-1,0) '_openfast.sh'],FileType="text",QuoteStrings="none")

elseif runIndex > 1000 && mod(runIndex,1000)==0
C(end+1,1) = {['openfast *_tasknum_$((SLURM_ARRAY_TASK_ID+' num2str(runIndex-1000) ')).fst']};
writecell(C,['run_' num2str((runIndex/1000)-1,0) '_openfast.sh'],FileType="text",QuoteStrings="none")

elseif runIndex > 1000 && mod(runIndex,1000)~=0
modrunIndex = mod(runIndex,1000);
C(end+1,1) = {['openfast *_tasknum_$((SLURM_ARRAY_TASK_ID+' num2str(runIndex-modrunIndex) ')).fst']};  
writecell(C,['run_' num2str((runIndex/1000),0) '_openfast.sh'],FileType="text",QuoteStrings="none")
end


end