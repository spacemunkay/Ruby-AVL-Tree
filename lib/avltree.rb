class AVLTree
  attr_accessor :root
  def initialize(array = [])
    #create root
    @root = nil
    array.each do |n|
      insert n
    end
  end

  def insert(v)
    i_node = create_node(v)

    prev_node = nil
    curr_node = @root
    while !curr_node.nil?
      prev_node = curr_node
      if i_node.value < curr_node.value
        curr_node = curr_node.left
      else
        curr_node = curr_node.right
      end
    end

    if prev_node.nil?
      @root = i_node
    else
      i_node.parent = prev_node
      if i_node.value < prev_node.value
        prev_node.left = i_node
      else
        prev_node.right = i_node
      end
    end
    i_node.update_height
    @root = i_node.balance 
    i_node
  end

  def search(v)
    search_node(@root, v)
  end

  def delete(v)
    d = search(v)
    return nil if d.nil?

    if d.left == nil or d.right == nil
      n = d
    else #both children exist
      n = d.next
    end

    if !n.left.nil?
      b = n.left
    else
      b = n.right
    end

    b.parent = n.parent unless b.nil?
    
    if n.parent.nil?
      @root = b
    elsif n == n.parent.left
      n.parent.left = b
    else
      n.parent.right = b
    end

    d.value = n.value unless n == d

    if b.nil?
      n.parent.update_height 
      @root = n.balance
    else
      b.update_height
      @root = b.balance 
    end
    n
  end

  def print
    result = sort
    puts result.inspect
  end

  def sort
    result = Array.new
    sort_node(@root, result )
    result
  end

  def min
    @root.min
  end

  def max
    @root.max
  end



private
  def create_node(v = nil)
    n = AVLNode.new(:value => v)
  end

  def sort_node(n, array)
    if !n.nil?
      sort_node(n.left, array)
      array.push(n.value)
      sort_node(n.right, array)
    end
  end

  def search_node(n, v)
    if !n.nil?
      if n.value == v
        return n
      elsif v < n.value
        search_node(n.left,v) 
      else
        search_node(n.right,v)
      end
    end
  end
end

class AVLNode
  BAL_H = 1
  attr_accessor :height, :left, :right, :value, :parent
  def initialize args
    @height = 0
    @left = nil
    @right = nil
    @value = nil
    @parent = nil
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def balance
    rotate if difference.abs > BAL_H
    return self if @parent.nil?
    @parent.balance 
  end

  def update_height
    l_height = @left.nil? ? 0 : @left.height
    r_height = @right.nil? ? 0 : @right.height
    @height = ((l_height > r_height) ? l_height : r_height) + 1
    @parent.update_height unless @parent.nil?
  end

  def rotate
    if difference >= BAL_H
      #check if children should rotate too
      @right.rotate if @right.difference <= -BAL_H
      rotate_left
    elsif difference <= - BAL_H
      #check if children should rotate too
      @left.rotate if @left.difference >= BAL_H
      rotate_right
    end
  end

  def rotate_left
    #the old right is now the root
    root = @right
    root.parent = @parent
    #update the parent to point to the new root 
    if not @parent.nil?
      if @parent.right == self
        @parent.right = root
      else
        @parent.left = root
      end
    end

    #this node's right is now the root's left
    @right = root.left
    root.left.parent = self unless root.left.nil?

    #the root is now the parent of this node
    @parent = root
    #this node is now the root's left
    root.left = self
    root.left.update_height
    root
  end

  def rotate_right
    root = @left
    root.parent = @parent
    #update the parent to point to the new root 
    if not @parent.nil?
      if @parent.right == self
        @parent.right = root
      else
        @parent.left = root
      end
    end

    @left = root.right
    root.right.parent = self unless root.right.nil?

    @parent = root
    root.right = self
    root.right.update_height
    root
  end

  def difference
    r_height = @right.nil? ? 0 : @right.height
    l_height = @left.nil? ? 0 : @left.height
    r_height - l_height
  end

  def next
    if not @right.nil?
      @right.min 
    else
      curr_node = self
      p_node = @parent 
      while p_node != nil && curr_node == p_node.right
        curr_node = p_node
        p_node = p_node.parent
      end
      p_node
    end
  end

  def prev
    if not @left.nil?
      @left.max 
    else
      curr_node = self
      p_node = @parent 
      while p_node != nil && curr_node == p_node.left
        curr_node = p_node
        p_node = p_node.parent
      end
      p_node
    end
  end


  def min
    node = self
    while !node.left.nil?
      node = node.left 
    end
    node
  end

  def max
    node = self
    while !node.right.nil?
      node = node.right
    end
    node
  end

  def print_node
    out_s =  "\t\t\t\t\t\n"
    out_s += "\t\t#{@parent}\t\t\n"
    out_s += "#{@height}\t\t|#{@value}|\t\t\n"
    out_s += "\t#{@left}\t\t#{@right}\t\n"
    out_s +=  "\t\t\t\t\t\n"
    puts out_s
  end

  def print
    out_s = "#{@value} - "
    instance_variables.each do |i|
      out_s += "(#{i}: #{instance_variable_get(i.to_sym)})"
    end
    puts out_s
  end

  def to_s
    @value.to_s
  end

end

