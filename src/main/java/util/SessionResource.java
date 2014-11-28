package util;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@Path("session")
@Produces(MediaType.APPLICATION_JSON)
public class SessionResource {

    private static class CounterOutputStream extends OutputStream {

        long size = 0;

        @Override
        public void write(final int b) throws IOException {

            ++size;
        }

    }

    @XmlRootElement
    public static class SessionAttributeData {

        @XmlElement
        public String name;

        @XmlElement
        public boolean serializable;

        @XmlElement
        public long size;

        @XmlElement
        public String value;
    }

    @XmlRootElement
    public static class SessionAttributesData {

        @XmlElement
        public SessionAttributeData[] sessionAttributeData;

        @XmlElement
        public long totalSize;
    }

    @GET
    public Response getSessionData(@Context final HttpServletRequest request) {

        final HttpSession session = request.getSession(false);
        if (session == null) {
            return Response.noContent()
                    .build();
        }
        long totalSize = 0;
        final List<SessionAttributeData> sessionAttributes = new ArrayList<SessionAttributeData>();
        final Enumeration<String> e = session.getAttributeNames();
        while (e.hasMoreElements()) {
            final SessionAttributeData attributeData = new SessionAttributeData();
            attributeData.name = e.nextElement();
            attributeData.value = String.valueOf(session.getAttribute(attributeData.name));
            try {
                final CounterOutputStream cos = new CounterOutputStream();
                final ObjectOutputStream oos = new ObjectOutputStream(cos);
                oos.writeObject(session.getAttribute(attributeData.name));
                oos.close();
                attributeData.size = cos.size;
                totalSize += cos.size;
                attributeData.serializable = true;
            } catch (final IOException ex) {
                attributeData.serializable = false;
            }
            sessionAttributes.add(attributeData);
        }
        final SessionAttributesData sessionAttributesData = new SessionAttributesData();
        sessionAttributesData.totalSize = totalSize;
        sessionAttributesData.sessionAttributeData = sessionAttributes.toArray(new SessionAttributeData[0]);
        return Response.ok(sessionAttributesData)
                .build();
    }
}
