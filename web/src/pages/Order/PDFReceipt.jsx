import jsPDF from 'jspdf';
import 'jspdf-autotable';
import { pharmacyOrderAPI } from "@/api/orderApi.jsx";

const generateReceipt = async (orderId) => {
    try {
        const response = await pharmacyOrderAPI.getOrderDetail(orderId);
        if (response.code === 1 && Array.isArray(response.data)) {
            const orderDetails = response.data;
            const totalAmount = orderDetails.reduce((sum, item) => sum + item.price * item.quantity, 0);

            const doc = new jsPDF();
            const tableColumn = ["Product", "Quantity", "Price", "Total", "Manufacturer"];
            const tableRows = orderDetails.map(item => [
                item.productName,
                item.quantity,
                `$${item.price.toFixed(2)}`,
                `$${(item.quantity * item.price).toFixed(2)}`,
                item.manufacturerName
            ]);

            doc.setFontSize(20);
            doc.text('MediMate', doc.internal.pageSize.width / 2, 15, { align: 'center' });
            doc.setFontSize(12);
            doc.text(`Order Receipt`, doc.internal.pageSize.width / 2, 25, { align: 'center' });
            doc.text(`Order ID: ${orderId}`, 14, 35);

            doc.autoTable({
                head: [tableColumn],
                body: tableRows,
                startY: 40,
                styles: { fontSize: 8 },
                columnStyles: {
                    0: { cellWidth: 60 },
                    1: { cellWidth: 20, halign: 'center' },
                    2: { cellWidth: 25, halign: 'right' },
                    3: { cellWidth: 25, halign: 'right' },
                    4: { cellWidth: 50 }
                },
                headStyles: { fillColor: [41, 128, 185], textColor: 255 },
                alternateRowStyles: { fillColor: [242, 242, 242] }
            });

            doc.setFontSize(10);
            doc.text(`Total Amount: $${totalAmount.toFixed(2)}`, 14, doc.lastAutoTable.finalY + 10);

            doc.setFontSize(8);
            doc.text('Thank you for your purchase!', doc.internal.pageSize.width / 2, doc.internal.pageSize.height - 10, { align: 'center' });

            doc.save(`order_receipt_${orderId}.pdf`);
        } else {
            throw new Error("Failed to fetch order details");
        }
    } catch (error) {
        console.error("Error generating receipt:", error);
        // 这里可以添加一些错误处理逻辑，比如显示一个错误消息
    }
};

export default generateReceipt;