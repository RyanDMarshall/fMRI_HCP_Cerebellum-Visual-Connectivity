let i = 1
for file in $(ls *.o678*); do 
	let i=$i+1
	last_perm=$(tail -n 1 $file | awk '{print $3}')
	echo -n "${file}: ${last_perm}/5000  |";
	if (( i%3==0 )); then echo; fi;
done
