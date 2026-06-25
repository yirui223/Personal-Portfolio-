"""
时间复杂度：
    最优：O(n^2)
    最坏：O(n^2)
不稳定的排序算法
"""
# 定义select_sort(my_list) 选择排序
def select_sort(my_list):  #形参接受可变类型，则：形参的改变直接影响实参
    #获取列表长度
    n = len(my_list)
    #外循环，控制比较的：轮数
    for i in range(n - 1):
        #定义变量 min_index，记录住,本轮真正最小值的索引 （i在哪里 min_index就在哪里）
        min_index = i
        #内循环，控制每轮比较的：次数
        for j in range(i + 1, n):
        #具体的比较过程 索引min_index(初始值为i) 和索引j比较
            if my_list[j] < my_list[min_index]:
                min_index = j
        #说明本轮已经找到最小值，判断，并交换
        if min_index != i:
            my_list[min_index], my_list[i] = my_list[i], my_list[min_index]



#测试
if __name__ == '__main__':
    #定义列表，记录排序元素
    #my_list = [5,3,6,7,2]
    my_list = [2, 3, 5, 6, 7]
    # 调用函数 select_sort(my_list),进行排序
    select_sort(my_list)  # 实参，可变
    # 打印结果（因为形参的改变直接影响实参）
    print(my_list)