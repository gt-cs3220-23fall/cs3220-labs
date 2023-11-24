import os 
import random
import string
import sys
import numpy



def generate_random_data_for_4_4_systolic_array(a_size=(4,4),b_size=(4,4), c_size=(4,4), data_bitwdith=3, num_test=4):
    """
    This function generates random data for a 4x4 systolic array doing 4x4 matrix multiplication
    C = A * B
    """
    a_matrix_list = []
    b_matrix_list = []
    c_matrix_list = []
    for test_idx in range(num_test):
        #generate a random a matrix
        a_matrix = numpy.random.randint(0, 2**data_bitwdith, size=a_size)
        b_matrix = numpy.random.randint(0, 2**data_bitwdith, size=b_size)
        #c = numpy.matmul(a_matrix, b_matrix)
        c_matrix = numpy.matmul(a_matrix, b_matrix)
        a_matrix_list.append(a_matrix)
        b_matrix_list.append(b_matrix)
        c_matrix_list.append(c_matrix)
    a_matrix_merged = numpy.concatenate(a_matrix_list, axis=1)
    b_matrix_merged = numpy.concatenate(b_matrix_list, axis=0)
    c_matrix_merged = numpy.concatenate(c_matrix_list, axis=1)



    #shift the row of a matrix each by row_idx, and zero pad the front and back
    a_matrix_shifted = numpy.zeros((a_size[0], a_size[1]*num_test + a_size[0]-1))
    for row_idx in range(a_size[0]):
        a_matrix_shifted[row_idx][row_idx:row_idx+a_size[1]*num_test] = a_matrix_merged[row_idx]
    b_matrix_shifted = numpy.zeros((b_size[0]*num_test + b_size[0]-1, b_size[1]))
    for col_idx in range(b_size[1]):
        b_matrix_shifted[col_idx:col_idx+b_size[0]*num_test, col_idx] = b_matrix_merged[:, col_idx]
    c_matrix_shifted = numpy.zeros((c_size[0], c_size[1]*num_test + c_size[0]-1))
    for row_idx in range(c_size[0]):
        c_matrix_shifted[row_idx][row_idx:row_idx+c_size[1]*num_test] = c_matrix_merged[row_idx]
    a_matrix_shifted = a_matrix_shifted.astype(numpy.uint8)
    b_matrix_shifted = b_matrix_shifted.astype(numpy.uint8)
    c_matrix_shifted = c_matrix_shifted.astype(numpy.uint8)



    #store transposed a matrix and b matrix 
    a_matrix_shifted.T.tofile("a_matrix.bin")
    b_matrix_shifted.tofile("b_matrix.bin")
    c_matrix_shifted.T.tofile("c_matrix.bin")

    print("A matrix: ")
    print(a_matrix_shifted.T)
    print("B matrix: ")
    print(b_matrix_shifted)
    print("C matrix: ")
    print(c_matrix_shifted.T)

    print("A matrix combined hex string: ")
    for row in a_matrix_shifted.T:
        print("".join(["{:02x}".format(x) for x in row]))
    print("B matrix combined hex string: ")
    for row in b_matrix_shifted:
        print("".join(["{:02x}".format(x) for x in row]))
    print("C matrix combined hex string: ")
    for row in c_matrix_shifted.T:
        print("".join(["{:02x}".format(x) for x in row]))


def verify_results(gold_data_file, result_data_file, col_size = 4):
    """
    This function verifies the results of the systolic array
    """
    gold_data = numpy.fromfile(gold_data_file, dtype=numpy.uint8)
    result_data = numpy.fromfile(result_data_file, dtype=numpy.uint8)
    #reshape into a col_size of 4, unknown row size
    gold_data = gold_data.reshape(-1, col_size)
    result_data = result_data.reshape(-1, col_size)
    print("Gold data shape: ", gold_data.shape)
    print("Result data shape: ", result_data.shape)

    #1st row of gold data as start indicator
    start_indicator = gold_data[0]
    #last row of gold data as end indicator
    end_indicator = gold_data[-1]
    print("Start indicator for outputing results: ", start_indicator)
    print("End indicator for outputing results: ", end_indicator)

    #find the start indicator in result data
    start_indicator_idx = -1
    for row_idx in range(result_data.shape[0]):
        if numpy.array_equal(result_data[row_idx], start_indicator):
            start_indicator_idx = row_idx
            break
    print("Start indicator idx: ", start_indicator_idx)
    #if the start indicator is not found, return false
    if start_indicator_idx == -1:
        return False
    #find the end indicator in result data
    end_indicator_idx = -1
    for row_idx in range(result_data.shape[0]):
        if numpy.array_equal(result_data[row_idx], end_indicator):
            end_indicator_idx = row_idx
            break
    #if the end indicator is not found, return false
    if end_indicator_idx == -1:
        return False
    print("End indicator idx: ", end_indicator_idx)
    #take the data in between start and end indicator
    result_data = result_data[start_indicator_idx:end_indicator_idx+1]
    #compare the data
    if numpy.array_equal(gold_data, result_data):
        return True
    else:
        return False
    





if __name__ == "__main__":

    #take in the command line arguments
    mode = str(sys.argv[1])
    
    if mode == "gen_data":
        #generate a random int from 4 to 8
        num_test = random.randint(4,8)
        generate_random_data_for_4_4_systolic_array(num_test=num_test)
    else:
        result = verify_results("c_matrix.bin", "results.bin")
        if result:
            print("PASSED!")
        else:
            print("FAILED!")



