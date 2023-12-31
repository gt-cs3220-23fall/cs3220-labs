#!/bin/bash


part=$1

echo You have chosen to run $part tests

case $part in 
  part1) 
    rm part1_tests.log
    ;;
  part2) 
    rm part2_tests.log
    ;;
  part3) 
    rm part3_tests.log
    ;;
  part4) 
    rm part4_tests.log
    ;;
  part5)
	rm part5_tests.log
	;;
  part6)
	rm part6_tests.log
	;;
  part7)
	rm part7_tests.log
	;;
  towers)
    rm -f towers_tests.log
	;;
esac

case $part in
	part1)
		echo RUNNING PART1$'\n'
		for filename in $PWD/test/part1/*.mem;do
			echo $'\n'TESTING: $filename >> part1_tests.log
			IDMEMINITFILE=$filename make tests>> part1_tests.log
		done
		grep -E 'TESTING|Failed|Passed' part1_tests.log>part1_results.log
		echo "Total number of tests:"
		grep -i testing part1_tests.log | wc -l
		echo "Number of passed tests:"
		grep -i passed part1_tests.log | wc -l
		echo "Number of failed tests:"
		grep -i failed part1_tests.log | wc -l
	;;
	part2)
		echo RUNNING PART2$'\n'
		for filename in $PWD/test/part2/*.mem;do
			echo $'\n'TESTING: $filename >> part2_tests.log
			IDMEMINITFILE=$filename make tests>> part2_tests.log
		done
		grep -E 'TESTING|Failed|Passed' part2_tests.log>part2_results.log
		echo "Total number of tests:"
		grep -i testing part2_tests.log | wc -l
		echo "Number of passed tests:"
		grep -i passed part2_tests.log | wc -l
		echo "Number of failed tests:"
		grep -i failed part2_tests.log | wc -l
	;;
	part3)
		echo RUNNING PART3$'\n'
		for filename in $PWD/test/part3/*.mem;do
			echo $'\n'TESTING: $filename >> part3_tests.log
			IDMEMINITFILE=$filename make tests>> part3_tests.log
		done
		grep -E 'TESTING|Failed|Passed' part3_tests.log>part3_results.log
		echo "Total number of tests:"
		grep -i testing part3_tests.log | wc -l
		echo "Number of passed tests:"
		grep -i passed part3_tests.log | wc -l
		echo "Number of failed tests:"
		grep -i failed part3_tests.log | wc -l
	;;
	part4)
			echo RUNNING PART4$'\n'
			for filename in $PWD/test/part4/*.mem;do
					echo $'\n'TESTING: $filename >> part4_tests.log
					IDMEMINITFILE=$filename make tests>> part4_tests.log
			done
			grep -E 'TESTING|Failed|Passed' part4_tests.log>part4_results.log
			echo "Total number of tests:"
			grep -i testing part4_tests.log | wc -l
			echo "Number of passed tests:"
			grep -i passed part4_tests.log | wc -l
			echo "Number of failed tests:"
			grep -i failed part4_tests.log | wc -l
	;;
	part5)
			echo RUNNING PART5$'\n'
			for filename in $PWD/test/part5/*.mem;do
					echo $'\n'TESTING: $filename >> part5_tests.log
					IDMEMINITFILE=$filename make tests>> part5_tests.log
			done
			grep -E 'TESTING|Failed|Passed' part5_tests.log>part5_results.log
			echo "Total number of tests:"
			grep -i testing part5_tests.log | wc -l
			echo "Number of passed tests:"
			grep -i passed part5_tests.log | wc -l
			echo "Number of failed tests:"
			grep -i failed part5_tests.log | wc -l
	;;
	part6)
			echo RUNNING PART6$'\n'
			for filename in $PWD/test/part6/*.mem;do
					echo $'\n'TESTING: $filename >> part6_tests.log
					IDMEMINITFILE=$filename make tests>> part6_tests.log
			done
			grep -E 'TESTING|Failed|Passed' part6_tests.log>part6_results.log
			echo "Total number of tests:"
			grep -i testing part6_tests.log | wc -l
			echo "Number of passed tests:"
			grep -i passed part6_tests.log | wc -l
			echo "Number of failed tests:"
			grep -i failed part6_tests.log | wc -l
	;;
	part7)
			echo RUNNING PART7$'\n'
			for filename in $PWD/test/part7/*.mem;do
					echo $'\n'TESTING: $filename >> part7_tests.log
					IDMEMINITFILE=$filename make tests>> part7_tests.log
			done
			grep -E 'TESTING|Failed|Passed' part7_tests.log>part7_results.log
			echo "Total number of tests:"
			grep -i testing part7_tests.log | wc -l
			echo "Number of passed tests:"
			grep -i passed part7_tests.log | wc -l
			echo "Number of failed tests:"
			grep -i failed part7_tests.log | wc -l
	;;
	towers)
		echo RUNNING TOWERS$'\n'
		for filename in $PWD/test/towers/*.mem;do
			echo $'\n'TESTING: $filename >> towers_tests.log
			IDMEMINITFILE=$filename make tests >> towers_tests.log
		done
		grep -E 'TESTING|Failed|Passed' towers_tests.log > towers_results.log
		echo "Total number of tests:"
		grep -i testing towers_tests.log | wc -l
		echo "Number of passed tests:"
		grep -i passed towers_tests.log | wc -l
		echo "Number of failed tests:"
		grep -i failed towers_tests.log | wc -l
	;;
	all)
		echo RUNNING ALL$'\n'
		for filename in $PWD/test/part*/*.vmh;do
			echo $'\n'TESTING: $filename >> all_tests.log
			IDMEMINITFILE=$filename make tests>> all_tests.log
		done
		grep -E 'TESTING|Failed|Passed' all_tests.log>all_results.log
		echo "Total number of tests:"
		grep -i testing part3_tests.log | wc -l
		echo "Number of passed tests:"
		grep -i passed part3_tests.log | wc -l
		echo "Number of failed tests:"
		grep -i failed part3_tests.log | wc -l
	;;
	*)
		echo INVALID PART. Use part1, part2, part3, part4 or all as command line argument
	;;
esac
