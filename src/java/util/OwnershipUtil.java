package util;

import dal.HostelDAO;

/**
 * Utility for verifying data ownership.
 * Ensures landlords can only manipulate their own hostels and related data.
 */
public class OwnershipUtil {

    private OwnershipUtil() {
        // Utility class — prevent instantiation
    }

    /**
     * Verifies that a hostel belongs to the specified landlord.
     *
     * @param hostelId  the hostel to check
     * @param landlordId the landlord (user) to verify against
     * @return true if the hostel belongs to the landlord
     */
    public static boolean verifyHostelOwnership(int hostelId, int landlordId) {
        HostelDAO hostelDAO = new HostelDAO();
        try {
            return hostelDAO.isHostelOwnedBy(hostelId, landlordId);
        } finally {
            hostelDAO.close();
        }
    }
}
