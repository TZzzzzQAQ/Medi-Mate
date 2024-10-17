import jsPDF from 'jspdf';
import 'jspdf-autotable';

const convertToNZTime = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleString("en-NZ", { timeZone: "Pacific/Auckland", hour12: false });
};

const generateReport = (orders) => {
    const doc = new jsPDF();
    const tableColumn = ["Order ID", "User ID", "Amount", "Status", "Pharmacy ID", "Created At"];
    const tableRows = orders.map(order => [
        order.orderId,
        order.userId,
        `$${order.totalAmount?.toFixed(2) || '0.00'}`,
        ['Finish Order', 'Start Picking', 'Finish Picking'][order.status - 1],
        order.pharmacyId,
        convertToNZTime(order.createdAt)
    ]);

    doc.text('Order Report', 14, 15);
    doc.autoTable({
        head: [tableColumn],
        body: tableRows,
        startY: 20,
        styles: { fontSize: 8 },
        columnStyles: {
            0: { cellWidth: 35 },
            1: { cellWidth: 35 },
            2: { cellWidth: 25 },
            3: { cellWidth: 25 },
            4: { cellWidth: 25 },
            5: { cellWidth: 40 }
        }
    });

    doc.save("order_report.pdf");
};

export default generateReport;