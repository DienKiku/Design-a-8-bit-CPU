# Design-a-8-bit-CPU (IP Core)
# Phân tích chi tiết từ khối trong một thiết kế vi mạch
•	Hoạt động cơ bản của một CPU gồm các bước sau:
•	Lấy lệnh (Fetch) từ bộ nhớ lưu mã lệnh (instruction memory), còn gọi là bộ nhớ chương trình (program memory). Từng mã lệnh (Instruction code) mà CPU phải thực thi được lưu sẵn trong bộ nhớ chương trình. Các mã lệnh là chuỗi binary được biên dịch từ code C/C++ hoặc assembly code.
•	Giải mã lệnh (Decode) dựa trên mã binary của từng lệnh CPU sẽ giải mã xem lệnh đó là lệnh gì và tích cực các tín hiệu điều khiển tương ứng
•	Thực thi lệnh (Execute) là thực hiện các tính toán và xử lý tương ứng với mã lệnh đã được giả mã như cộng, trừ, nhân, chia, dịch, ...
•	Truy xuất bộ nhớ (Memory Access) đọc/ghi bộ nhớ
•	Lưu kết quả (Write Back) là thực hiện lưu lại các kết quả sau quá trình Execute đến vị trí mà lệnh yêu cầu, ví dụ như các thanh ghi
•	Các thành phần cơ bản của CPU
•	Bộ đêm chương trình PC (Program Counter) tạo giá trị địa chỉ truy cập bộ nhớ chương trình để lấy lệnh
•	Bộ nhớ chương trình (Program memory) lưu các lệnh mà CPU sẽ thực thi
•	Thanh ghi lưu mã lệnh IR (Instruction Register) lưu mã binary lấy từ bộ nhớ lệnh
•	Bộ giải mã lệnh Decoder
•	Các thanh ghi dùng để lưu giá trị trước và sau khi CPU thực thi tính toán (execute)
•	Bộ tính toán số học ALU (Arithmetic Logic Unit) thực thi các phép tính cộng, trừ, nhân, chia, dịch, ....
•	Bộ nhớ dữ liệu (Data memory) lưu các dữ liệu được sử dụng bởi các lệnh truy xuất bộ nhớ
# Phân tích tập lệnh của SPCU
CPU là một thiết kế đặc biệt, trong đó cấu trúc tập lệnh sẽ có ảnh hưởng lớn đến cấu trúc phần cứng sẽ thực hiện nên từng lệnh của CPU cần được phân tích cụ thể trước khi phân tích chi tiết hơn. Cấu trúc mã lệnh được lựa chọn ở đây là:
•	16 bit
•	Độ dài cố định (kiểu RISC - Reduced Instruction Set Computing )
# Đặc điểm và chức năng
1.	Chức năng theo yêu cầu thiết kế
1.	Hỗ trợ 16 lệnh
2.	Bus dữ liệu 8 bit
2.	Chức năng được lựa chọn để thiết kế
1.	Kiến trúc RISC với độ dài mã lệnh là 16 bit
2.	Bộ nhớ chương trình và bộ nhớ dữ liệu dùng chung có dung lượng 256 byte
3.	Bộ tính toán số học ALU hỗ trợ ADD, SUB, AND và OR
4.	Hỗ trợ 4 thanh ghi tính toán R0, R1, R2 và R3 ứng với trường Rd và Rs chỉ có 2 bit
# Sơ đồ khối
Từ những phân tích ở bước "nghiên cứu và tìm hiểu" và đặc điểm hỗ trợ, một sơ đồ khối cho ví dụ SCPU được thể hiện như sau:
•	Khối Fetch
•	Khối Memory là bộ nhớ chương trình và cũng là bộ nhớ dữ liệu 
•	Khối IR là thanh ghi 8 bit lưu mã lệnh lấy từ memory
•	Khối DR là thanh ghi 8 bit lưu dữ liệu từ memory. Thanh ghi này sẽ lưu giá trị IMM của các lệnh nhảy, lệnh LW và SW (số thứ tự từ 9 đến 16 trong bảng mã lệnh)
•	Khối PC: Tính toán giá trị PC truy xuất bộ nhớ chương trình lấy đầu vào từ:
•	Ngõ ra Decoder để lấy địa chỉ truy xuất đối với lệnh đọc bộ nhớ LW và ghi bộ nhớ SW
•	Thanh ghi DR để lấy giá trị IMM cho các lệnh nhảy
•	Khối Decoder giải mã lệnh tạo tín hiệu điều khiển các khối khác và cấp dữ liệu ghi vào Memory đối với lệnh SW. Đây là khối sẽ chứa các thanh ghi R0, R1, R2 và R3
•	Khối Execute chứa ALU thực thi tính toán số học và tạo giá trị cập nhật các thanh ghi tính toán R0, R1, R2 và R3
# Sơ đồ tín hiệu giao tiếp và mô tả
Đối với thiết CPU này, chúng ta chỉ có 2 tín hiệu giao tiếp là:
•	Xung clock đồng bộ để SCPU chạy liên tục. Xung clock sẽ tích cực cạnh lên.
•	Tín hiệu reset để khởi động SCPU. Tín hiệu reset tích cực mức thấp
Thiết kế có các thanh ghi mà người dùng có thể tác động khi lập trình gồm:
•	Thanh ghi chương trình PC:
•	Chức năng: Chứa địa chỉ truy xuất bộ nhớ chương trình. Người sử dụng có thể tác động bởi lệnh nhảy
•	Độ rộng: 8 bit
•	Thanh ghi tính toán R0, R1, R2, R3:
•	Chức năng: Chứa giá trị dùng để tính toán và kết quả tính toán. Người sử dụng có thể tác động bởi các lệnh có trường hoặc vùng Rd hoặc Rs.
•	Độ rộng: 8 bit
# Phân tích phần giao tiếp với bộ nhớ
Trong thiết kế này, chúng ta sử dụng bộ nhớ có dung lượng 256 byte, mỗi ô nhớ là 8 bit. Trong khi đó, mã lệnh có độ dài 16 bit. Như vậy, một mã lệnh sẽ được chia làm 2 phần là 8 bit MSB (bit 15 đến 8) và 8 bit LSB (bit 7 đến 0) để lưu trong 2 ô nhớ.
Quan sát mã lệnh, các bạn sẽ thấy có 2 nhóm lệnh là nhóm có IMM và nhóm không có IMM. Nhóm có IMM làm nhóm bắt buộc phải dùng 2 ô nhớ liên tiếp nhau để lưu mã lệnh. Nhóm không có IMM thì chỉ cần 1 ô nhớ để lưu 8 bit MSB vì 8 bit LSB không sử dụng.
Giả sử rằng bộ nhớ hoạt động trong 1 chu kỳ xung clock clk. Nghĩa là, khi một lệnh đọc/ghi được đưa đến bộ nhớ ở một cạnh lên xung clock thì ngay cạnh lên xung clock tiếp theo bộ nhớ đã thực hiện xong.
# Phân tích hoạt động của các lệnh
Chu kỳ hoạt động của các lệnh như sau:
1.	Chu kỳ 1: Các lệnh được fetch vào thanh ghi lệnh IR. Đồng thời PC tăng một đơn vị chỉ đến ô nhớ tiếp theo. Chu kỳ này áp dụng cho tất cả các lệnh. Khối FETCH hoạt động trong chu kỳ này.
1.	Lệnh NOP là lệnh không thực thi tác vụ nào sẽ được kết thúc trong chu kỳ này.
2.	Chu kỳ 2: Lệnh đã có trong IR được giải mã để tạo ra các tín hiệu điều khiển, khối DECODER hoạt động. Đồng thời:
1.	Lệnh được thực thi nếu là lệnh 1 byte, khối EXCUTE hoạt động
2.	Đọc bộ nhớ lưu giá trị IMM vào thanh ghi DR nếu là lệnh 2 byte
3.	Chu kỳ 3: Thực thi lệnh 2 byte cập nhật giá trị PC mới, khối FETCH hoạt động vì khối này chứa PC.
# Tìm tín hiệu ngõ vào khối FETCH
Khối FETCH chứa các khối con là MEMORY, PC, DR và IR. Các chức năng chính của khối này là:
1.	Tính toán PC
2.	Truy cập MEMORY
3.	Cập nhật DR
4.	Cập nhật IR
Với chức năng tính toán PC, chúng ta sẽ thực hiện như sau:
1.	Chức năng "tính toán PC" cần thông tin nào?
1.	PC là một thanh ghi => Cần xung clock clk
2.	PC cần reset về đầu chương trình để chạy => Cần tín hiệu reset
3.	PC cần được cập nhật giá trị => Cần tín hiệu cho biết khi nào PC cập nhật giá trị
4.	PC sẽ cập nhật giá trị giá trị như sau:
1.	PC tự tăng giá trị lên 1 đơn vị => không cần tín hiệu ngoài
2.	PC có thể lấy giá trị từ IMM được lưu trong thanh ghi DR ở các lệnh JEQ, JNE, JGT, JLT, JMP => DR chứa trong FETCH nên không cần tín hiệu ngoài
5.	Do PC nhận 2 đầu vào, tự tăng hoặc từ DR, nên cần có tín hiệu để chọn giá trị PC sẽ được cập nhật
2.	Thông tin trên lấy từ đâu?
1.	Xung clock clk: Được cấp từ ngoài CPU
2.	Tín hiệu reset rst_n: Được cấp từ ngoài CPU
3.	Tín hiệu cập nhật PC: Được cấp từ khối DECODER vì khối này giải mã lệnh sẽ biết lệnh đó là lệnh nào và thực hiện mấy chu kỳ => đặt tên dc_load_pc
4.	Tín hiệu lựa chọn giá trị PC sẽ được cập nhật: Được cấp từ khối DECODER vì khối này giải mã lệnh sẽ biết lệnh đó là lệnh nào => đặt tên dc_imm
Với chức năng truy cập MEMORY, chúng ta thực hiện như sau:
1.	Chức năng "truy cập MEMORY" cân thông tin nào?
1.	MEMORY là bộ nhớ đồng bộ => cần xung clock clk
2.	MEMORY cần thông tin truy cập là đọc hay ghi => tín tín hiệu điều khiển các năng đọc/ghi
3.	MEMORY cần địa chỉ truy cập có thể là
1.	PC => không cần tín hiệu ngoài
2.	IMM được lưu trong DR đối với lệnh LI => không cần tín hiệu ngoài
3.	Địa chỉ lưu trong 1 ô nhớ của MEMORY đối với lệnh LWR, SWR, LWI hoặc SWI => cần giá trị thanh ghi Rs đối với lệnh LWR và SWR
4.	Do địa chỉ MEMORY có thể là 1 trong 3 giá trị trên nên cần tín hiệu lựa chọn giá trị đúng
5.	MEMORY cần bus dữ liệu ghi => tín hiệu bus dữ liệu ghi
2.	Thông tin trên lấy từ đâu?
1.	Xung clock clk
2.	Tín hiệu điều khiển đọc/ghi: Được cấp từ khối DECODER vì khối này giải mã lệnh sẽ biết lệnh nào đọc hay ghi bộ nhớ => đặt tên dc_mem_wr. Nếu tín hiệu này bằng 1 sẽ là tác vụ ghi MEMORY và ngược lại là đọc MEMORY
3.	Địa chỉ của MEMORY => Chỉ có giá trị thanh ghi Rs là tín hiệu ngoài cần lấy từ khối DECODER, dặt tên là dc_rs[7:0]
4.	Tín hiệu lựa chọn giá trị địa chỉ => Được cấp từ khối DECODER vì khối này giải mã lệnh sẽ biết lệnh ghi/đọc lấy giá trị địa chỉ từ đâu => đặt tên là dc_addr_sel[1:0]. Tín hiệu 2 bit vì có 3 giá trị cần được xác định
5.	Bus dữ liệu ghi => Lấy từ DECODER vì chỉ có 2 lệnh ghi vào MEMORY là SWR và SWI đều lấy giá trị Rd để ghi vào MEMORY => đặt tên là dc_rd[7:0]
Tương tự, với chức năng cập nhật DR và IR, cả 2 chức năng này đều lấy giá trị từ MEMORY và cần một tín hiệu điều khiển để biết khi nào cập nhật IR và khi nào cập nhật DR:
1.	Tín hiệu điều khiển cập nhật giá trị IR lấy từ DECODER dc_load_ir
2.	Tín hiệu điều khiển cập nhật giá trị DR lấy từ DECODER dc_load_dr
# Tìm tín hiệu ngõ vào khối DECODER
DECODER là khối có chức năng:
1.	Giải mã lệnh và tạo tín hiệu điều khiển các khối khác
2.	Chứa các thanh ghi R0, R1, R2 và R3
Các bạn hãy thực hiện tương tự để tìm các tín hiệu ngõ vào. Ở đây, các tín hiệu chỉ được mô tả lại chức năng:
1.	Xung clock clk
2.	Tín hiệu reset rst_n tích cực mức thấp
3.	fetch_ir[7:0] mã lệnh lấy từ khối FETCH
4.	fetch_dr[7:0] là giá trị IMM lấy từ thanh ghi DR, khối DECODER sử dụng giá trị này để nạp cho các thanh ghi R0, R1, R2, R3 ở lệnh LI
5.	ex_dout[7:0] giá trị tính toán từ khối EXECUTE để cập nhật giá trị các thanh ghi R0, R1, R2 hoặc R3 ở lệnh AND, OR, ADD, SUB, LWR, MOV, LWI, LI.
6.	fetch_mem_dout[7:0] giá trị đọc MEMORYlấy từ khối FETCH vì lệnh LWI và LWR dữ liệu đọc từ MEMORY được lấy và lưu vào thanh ghi Rd
# Tìm tín hiệu ngõ vào khối EXECUTE
Khối EXECUTE thực hiện chức năng chính là tính toán số học và tạo kết quả cập nhật cho các thanh ghi R0, R1, R2 và R3. Các tín hiệu ngõ vào mà khối EXECUTE cần là:
1.	dc_rs[7:0] Giá trị thanh ghi Rs trong các lệnh tính toán
2.	dc_rd[7:0] Giá trị thanh ghi Rd trong các lệnh tính toán
3.	dc_op[1:0] Để lựa chọn phép toán sẽ thực thi là AND, OR, ADD hay SUB








