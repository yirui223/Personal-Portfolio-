"""
时间复杂度：
    最优：O(n)   假设顺序都排好，也就只用执行外循环
    最坏：O(n^2)
稳定的排序算法
"""
# 定义insert_sort(my_list) 选择排序
def insert_sort(my_list):  #形参接受可变类型，则：形参的改变直接影响实参
    #获取列表长度
    n = len(my_list)                       #假设列表长度为5
    #外循环，控制：比较的轮数
    for i in range(1, n):                  # i = 1,2,3,4
        # 内循环，每轮比较的总次数
        for j in range(i,0,-1):            #j = (1),(2,1),(3,2,1),(4,3,2,1)
            # J来比较J-1
            if my_list[j] < my_list[j-1]:  #j-1=(0),(1,0),(2,1,0),(3,2,1,0)
                my_list[j], my_list[j-1] = my_list[j-1], my_list[j]
            else:
                #说明元素找到了自己的位置，退出即可。（结束内循环，开始新的一轮内循环）
                break


#测试
if __name__ == '__main__':
    #定义列表，记录排序元素
    #my_list = [5,3,6,7,2]
    my_list = [2, 3, 5, 6, 7]
    # 调用函数 insert_sort(my_list),进行排序
    insert_sort(my_list)  # 实参，可变
    # 打印结果（因为形参的改变直接影响实参）
    print(my_list)