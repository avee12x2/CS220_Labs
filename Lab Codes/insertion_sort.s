        # Insertion Sort in MIPS
        # Assumptions:
        #   $s0 = Base address of the array.
        #   $s1 = Number of elements (n).

        # Registers usage:
        #   $t0 = i (current index for outer loop)
        #   $t1 = key (element to be inserted)
        #   $t2 = j (index for inner loop)
        #   $t3 = temporary: holds array[j] value.
        #   $t4 = temporary for computing address offsets.
        #   $t5 = temporary for computing addresses (target for store).
        #   $t6 = temporary: used for computing offset (i or j multiplied by 4).
        #   $t7,$t9 = temporary addresses.

        # Initialize i = 1.
        addi    $t0, $zero, 1         # t0 = 1

loop_i: # Outer loop: for each index i from 1 to n-1
        # If i >= n, then sorting is finished.
        bleq    $s1, $t0, end_sort    # if ($s1 <= $t0) branch to end_sort

        # Compute address of array[i]: addr = base + i*4.
        sll     $t6, $t0, 2           # t6 = i * 4
        add     $t7, $s0, $t6         # t7 = base address + offset
        lw      $t1, 0($t7)           # key = array[i] --> t1

        # Initialize inner loop index j = i - 1.
        addi    $t2, $t0, -1         # t2 = i - 1

loop_j: # Inner loop: shift elements that are greater than key.
        # If j < 0, then we're done shifting.
        slt     $t8, $t2, $zero      # t8 = 1 if j < 0, else 0
        bne     $t8, $zero, exit_j   # if (t8 != 0) branch to exit_j

        # Load array[j]:
        sll     $t6, $t2, 2          # t6 = j * 4
        add     $t9, $s0, $t6        # t9 = base + (j*4)
        lw      $t3, 0($t9)          # t3 = array[j]

        # Compare array[j] with key:
        # Branch if array[j] > key.
        bgt     $t3, $t1, shift_elem
        # If NOT (array[j] > key) then exit inner loop.
        j       exit_j

shift_elem:
        # Shift array[j] to array[j+1]:
        addi    $t4, $t2, 1          # t4 = j + 1
        sll     $t4, $t4, 2          # t4 = (j+1) * 4 (compute target offset)
        add     $t5, $s0, $t4        # t5 = base + (j+1)*4
        sw      $t3, 0($t5)          # array[j+1] = array[j]
        
        # Decrement j: j = j - 1.
        addi    $t2, $t2, -1
        j       loop_j               # Repeat inner loop

exit_j:
        # Insert the key into its proper place.
        addi    $t4, $t2, 1          # t4 = j + 1
        sll     $t4, $t4, 2          # t4 = (j+1)*4
        add     $t5, $s0, $t4        # t5 = base + (j+1)*4
        sw      $t1, 0($t5)          # array[j+1] = key

        # Increment i.
        addi    $t0, $t0, 1
        j       loop_i

end_sort:
        exit             # End of sort; infinite loop (or branch to further code)
