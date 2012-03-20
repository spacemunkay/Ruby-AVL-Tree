require 'test/unit'
require 'avltree'

class TestAVLTree < Test::Unit::TestCase

  def setup
    #
    #        2
    #     1     4
    #          3 5
    #
    @tree = AVLTree.new [1,2,5,4,3]
    #
    #          4
    #      2       6
    #     1 3     5 7
    #
    @rot_tree = AVLTree.new [4,2,6,3,1,5,7]
  end

  def test_sort
    assert_equal "[1, 2, 3, 4, 5]", @tree.sort.inspect
  end

  def test_search
    assert_not_nil @tree.search(1)
    assert_not_nil @tree.search(4)
    assert_nil @tree.search(0)
    assert_nil @tree.search(6)
  end

  def test_min
    assert_equal 1, @tree.min.value
    assert_equal 1, @tree.search(1).min.value
    assert_equal 3, @tree.search(4).min.value
  end

  def test_max
    assert_equal 5, @tree.max.value
    assert_equal 5, @tree.search(2).max.value
    assert_equal 5, @tree.search(4).max.value
    assert_equal 5, @tree.search(5).max.value
  end

  def test_next
    assert_equal 2, @tree.search(1).next.value
    assert_equal 3, @tree.search(2).next.value
    assert_nil @tree.search(5).next
  end

  def test_prev
    assert_nil @tree.search(1).prev
    assert_equal 4, @tree.search(5).prev.value
    assert_equal 3, @tree.search(4).prev.value
    assert_equal 2, @tree.search(3).prev.value
  end

  def test_delete

    @tree.delete 2
    assert_equal "[1, 3, 4, 5]", @tree.sort.inspect
    @tree.delete 4
    assert_equal "[1, 3, 5]", @tree.sort.inspect
    @tree.delete 3
    assert_equal "[1, 5]", @tree.sort.inspect
    @tree.delete 1
    assert_equal "[5]", @tree.sort.inspect

    @rot_tree.delete 1
    assert_equal 4.to_s, @rot_tree.root.to_s
    @rot_tree.delete 2
    assert_equal 4.to_s, @rot_tree.root.to_s
    @rot_tree.delete 3
    #should have to rotate
    assert_equal 6.to_s, @rot_tree.root.to_s
    assert_equal 4.to_s, @rot_tree.root.left.to_s
    assert_equal 7.to_s, @rot_tree.root.right.to_s
  end

  def test_rotate_left
    root = @rot_tree.root
    t_node = @rot_tree.search(4)
    s_node = @rot_tree.search(6)

    assert_equal 4.to_s, root.to_s
    assert_equal t_node.to_s, root.to_s
    assert_equal s_node.to_s, t_node.right.to_s
    
    t_node.rotate_left

    t_node = @rot_tree.search(4)
    root = t_node.parent

    #root
    assert_equal nil.to_s, root.parent.to_s
    assert_equal 7.to_s, root.right.to_s
    assert_equal t_node.to_s, root.left.to_s
    
    #t_node
    assert_equal root.to_s, t_node.parent.to_s
    assert_equal 2.to_s, t_node.left.to_s
    assert_equal 5.to_s, t_node.right.to_s
  end

  def test_rotate_right
    root = @rot_tree.root
    t_node = @rot_tree.search(4)
    s_node = @rot_tree.search(2)

    #root.print
    #t_node.print
    #s_node.print

    assert_equal 4.to_s, root.to_s
    assert_equal t_node.to_s, root.to_s
    assert_equal s_node.to_s, t_node.left.to_s
    
    t_node.rotate_right

    t_node = @rot_tree.search(4)
    root = t_node.parent

    #root
    assert_equal nil.to_s, root.parent.to_s
    assert_equal 4.to_s, root.right.to_s
    
    #t_node
    assert_equal root.to_s, t_node.parent.to_s
    assert_equal 3.to_s, t_node.left.to_s
    assert_equal 6.to_s, t_node.right.to_s
  end

  def test_balance
    #@tree.root.print
    #@tree.search(1).print
    #@tree.search(2).print
    #@tree.search(5).print
    #@tree.search(4).print
    #@tree.search(3).print
  end

end
